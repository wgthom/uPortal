/**
 * Copyright � 2001 The JA-SIG Collaborative.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. Redistributions of any form whatsoever must retain the following
 *    acknowledgment:
 *    "This product includes software developed by the JA-SIG Collaborative
 *    (http://www.jasig.org/)."
 *
 * THIS SOFTWARE IS PROVIDED BY THE JA-SIG COLLABORATIVE "AS IS" AND ANY
 * EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE JA-SIG COLLABORATIVE OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

package org.jasig.portal.channels;

import org.xml.sax.DocumentHandler;
import java.util.*;
import java.io.*;
import java.net.*;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import javax.servlet.http.Cookie;
import org.w3c.tidy.*;
import org.jasig.portal.*;
import org.jasig.portal.utils.XSLT;

/**
 * <p>A channel which transforms and interacts with dynamic XML or HTML.</p>
 *
 * <p>Channel parameters to be supplied:</p>
 * <ol>
 *  <li>"cw_xml" - a URI for the source XML document
 *  <li>"cw_ssl" - a URI for the corresponding .ssl (stylesheet list) file
 *  <li>"cw_xslTitle" - a title representing the stylesheet (optional)
 *                  <i>If no title parameter is specified, a default
 *                  stylesheet will be chosen according to the media</i>
 *  <li>"cw_xsl" - a URI for the stylesheet to use
 *                  <i>If <code>cw_xsl</code> is supplied, <code>cw_ssl</code>
 *                  and <code>cw_xslTitle</code> will be ignored.
 *  <li>"cw_passThrough" - indicates that RunTimeData is to be passed through.
 *                  <i>If <code>passThrough</code> is supplied, and not set
 *		    to "none", additional RunTimeData parameters and values
 *		    will be passed as request parameters to the XML URI.
 *  <li>"cw_tidy" - output from <code>xmlUri</code> will be passed though Jtidy
 *  <li>"cw_info" - a URI to be called for the <code>info</code> event.
 *  <li>"cw_help" - a URI to be called for the <code>help</code> event.
 *  <li>"cw_edit" - a URI to be called for the <code>edit</code> event.
 *  <li>"cw_reset" - an instruction to return to reset internal variables.
 *		   The value <code>return</code> resets <code>cw_xml</code>
 *		   to its last value before changed by button events.  The
 *		   value "reset" returns all variables to the static data
 *		   values.  Runtime data parameter only.
 * </ol>
 * <p>The static parameters above can be updated by including
 *    parameters of the same name in the HttpRequest string.
 * </p>
 * <p>This channel can be used for all XML formats including RSS.
 *    All static data parameters as well as additional runtime data parameters
 *    passed to this channel via HttpRequest will in turn be passed on to the
 *    XSLT stylesheet as stylesheet parameters.  They can be read in the
 *    stylesheet as follows:
 *    <code>&lt;xsl:param
 *    name="yourParamName"&gt;aDefaultValue&lt;/xsl:param&gt;</code>
 * </p>
 * @author Andrew Draskoy, andrew@mun.ca
 * @author Sarah Arnott, sarnott@mun.ca
 * @version $Revision$
 */
public class CWebProxy implements org.jasig.portal.IChannel
{
  protected String fullxmlUri;
  protected String buttonxmlUri;
  protected String xmlUri;
  protected String passThrough;
  protected String tidy;
  protected String sslUri;
  protected String xslTitle;
  protected String xslUri;
  protected String infoUri;
  protected String helpUri;
  protected String editUri;
  protected ChannelRuntimeData runtimeData;
  protected String media;
  protected Vector cookies;
  protected Timer timer;
  protected boolean supportSetCookie2;

  protected static String fs = File.separator;
  protected static String stylesheetDir = GenericPortalBean.getPortalBaseDir () + "webpages" + fs + "stylesheets" + fs + "org" + fs + "jasig" + fs + "portal" + fs + "CWebProxy" + fs;

  public CWebProxy ()
  {
    this.cookies = new Vector();
    this.timer = new Timer();
    this.supportSetCookie2 = false;
    this.buttonxmlUri = null;
  }

  // Get channel parameters.
  public void setStaticData (ChannelStaticData sd)
  {
    try
    {
      // to add: if not already set, make a copy of sd for the "reset" command
      this.xmlUri = sd.getParameter ("cw_xml");
      this.sslUri = sd.getParameter ("cw_ssl");
      this.fullxmlUri = sd.getParameter ("cw_xml");
      this.passThrough = sd.getParameter ("cw_passThrough");
      this.tidy = sd.getParameter ("cw_tidy");
      this.infoUri = sd.getParameter ("cw_info");
      this.helpUri = sd.getParameter ("cw_help");
      this.editUri = sd.getParameter ("cw_edit");
    }
    catch (Exception e)
    {
      Logger.log (Logger.ERROR, e);
    }
  }

  public void setRuntimeData (ChannelRuntimeData rd)
  {
    runtimeData = rd;

    String xmlUri = runtimeData.getParameter("cw_xml");
    if (xmlUri != null) {
       this.xmlUri = xmlUri;
       // don't need an explicit reset if a new URI is provided.
       buttonxmlUri = null;
    }

    String sslUri = runtimeData.getParameter("cw_ssl");
    if (sslUri != null)
       this.sslUri = sslUri;

    String xslTitle = runtimeData.getParameter("cw_xslTitle");
    if (xslTitle != null)
       this.xslTitle = xslTitle;

    String xslUri = runtimeData.getParameter("cw_xsl");
    if (xslUri != null)
       this.xslUri = xslUri;

    String passThrough = runtimeData.getParameter("cw_passThrough");
    if (passThrough != null)
       this.passThrough = passThrough;

    String tidy = runtimeData.getParameter("cw_tidy");
    if (tidy != null)
       this.tidy = tidy;

    String infoUri = runtimeData.getParameter("cw_info");
    if (infoUri != null)
       this.infoUri = infoUri;

    String editUri = runtimeData.getParameter("cw_edit");
    if (editUri != null)
       this.editUri = editUri;

    String helpUri = runtimeData.getParameter("cw_help");
    if (helpUri != null)
       this.helpUri = helpUri;

    // reset is a one-time thing.
    String reset = runtimeData.getParameter("cw_reset");
    if (reset != null) {
       if (reset.equalsIgnoreCase("return")) {
          buttonxmlUri = null;
       }
       // else if (reset.equalsIgnoreCase("reset")) {
       //  call setStaticData with our cached copy.
       // }
    }

    media = runtimeData.getMedia();

    if ( buttonxmlUri != null )
	fullxmlUri = buttonxmlUri;
    else {
    //if (this.passThrough != null )
    //  Logger.log (Logger.DEBUG, "CWebProxy: passThrough: "+this.passThrough);

    // Is this a case where we need to pass request parameters to the xmlURI?
    if ( this.passThrough != null &&
       !this.passThrough.equalsIgnoreCase("none") &&
         ( this.passThrough.equalsIgnoreCase("all") ||
           runtimeData.getParameter("cw_inChannelLink") != null ) )
    {
      Logger.log (Logger.DEBUG, "CWebProxy: xmlUri is " + this.xmlUri);

      StringBuffer newXML = new StringBuffer().append(this.xmlUri);
      String appendchar = "?";

      // want all runtime parameters not specific to WebProxy
      Enumeration e=runtimeData.getParameterNames ();
      if (e!=null)
        {
          while (e.hasMoreElements ())
            {
              String pName = (String) e.nextElement ();
              if ( !pName.startsWith("cw_") )
              {
                newXML.append(appendchar);
                appendchar = "&";
                newXML.append(pName);
                newXML.append("=");
                newXML.append(URLEncoder.encode(runtimeData.getParameter(pName)));
              }
            }
        }
      fullxmlUri = newXML.toString();
      Logger.log (Logger.DEBUG, "CWebProxy: fullxmlUri now: " + fullxmlUri);
    }
    }
  }

  /**
   * Process portal events.  Currently supported events are
   * EDIT_BUTTON_EVENT, HELP_BUTTON_EVENT, and ABOUT_BUTTON_EVENT.
   * These three work by changing the xmlUri.  The new Uri should
   * contain a link that will refer back to the old one at the end
   * of its task.
   * @param ev the event
   */
  public void receiveEvent (PortalEvent ev)
  {
    int evnum;

    evnum = ev.getEventNumber();
    if (evnum == ev.EDIT_BUTTON_EVENT && this.editUri != null)
          this.buttonxmlUri = this.editUri;
    else if (evnum == ev.HELP_BUTTON_EVENT && this.helpUri != null)
	  this.buttonxmlUri = this.helpUri;
    else if (evnum == ev.ABOUT_BUTTON_EVENT && this.infoUri != null)
          this.buttonxmlUri = this.infoUri;

      // case ev.UNSUBSCRIBE:
      //   // remove db entry for channel
      //   break;
  }

  // Access channel runtime properties.
  public ChannelRuntimeProperties getRuntimeProperties ()
  {
    return new ChannelRuntimeProperties ();
  }

  public void renderXML (DocumentHandler out) throws PortalException
  {
    String xml;

    try
    {
      xml = getXmlString (fullxmlUri);
    }
    catch (Exception e)
    {
      throw new ResourceMissingException (fullxmlUri, "", e.getMessage());
    }

    runtimeData.put("baseActionURL", runtimeData.getBaseActionURL());

    // Runtime data parameters gets handed to the stylesheet.
    // Add any static data parameters so it gets a full set of variables.
    // Possibly this should be a copy.
    if (xmlUri != null)
      runtimeData.put("cw_xml", xmlUri);
    if (sslUri != null)
      runtimeData.put("cs_ssl", sslUri);
    if (xslTitle != null)
      runtimeData.put("cw_xslTitle", xslTitle);
    if (xslUri != null)
      runtimeData.put("cw_xsl", xslUri);
    if (passThrough != null)
      runtimeData.put("cw_passThrough", passThrough);
    if (tidy != null)
      runtimeData.put("cw_tidy", tidy);
    if (infoUri != null)
      runtimeData.put("cw_info", infoUri);
    if (helpUri != null)
      runtimeData.put("cw_help", helpUri);
    if (editUri != null)
      runtimeData.put("cw_edit", editUri);

    try
    {
      if (xslUri != null)
        XSLT.transform(xml, new URL(xslUri), out, runtimeData);
      else
      {
        if (xslTitle != null)
          XSLT.transform(xml, new URL(sslUri), out, runtimeData, xslTitle, media);
        else
          XSLT.transform(xml, new URL(sslUri), out, runtimeData, media);
      }
    }
    catch (org.xml.sax.SAXException e)
    {
      throw new GeneralRenderingException("problem performing the transformation");
    } catch (IOException i) {
      StringWriter sw = new StringWriter();
      i.printStackTrace(new PrintWriter(sw));
      sw.flush();
      throw new GeneralRenderingException(sw.toString());
    }
  }

  /**
   * Get the contents of a URI as a String but send it through tidy first.
   * Also includes support for cookies.  
   * @param uri the URI
   * @return the data pointed to by a URI
   */
  private String getXmlString (String uri) 
  throws IOException, MalformedURLException, PortalException, ParseException
  {
    URL url = new URL (UtilitiesBean.fixURI(uri));
    URLConnection urlConnect = url.openConnection();

    sendAndStoreCookies(urlConnect);

    String xml;
    if ( (tidy != null) && (tidy.equalsIgnoreCase("on")) )
    {
      Tidy tidy = new Tidy ();
      tidy.setXHTML (true);
      tidy.setDocType ("omit");
      tidy.setQuiet(true);
      tidy.setShowWarnings(false);
      tidy.setNumEntities(true);
      tidy.setWord2000(true);
      if ( System.getProperty("os.name").indexOf("Windows") != -1 )
         tidy.setErrout( new PrintWriter ( new FileOutputStream (new File ("nul") ) ) );
      else
         tidy.setErrout( new PrintWriter ( new FileOutputStream (new File ("/dev/null") ) ) );
      ByteArrayOutputStream stream = new ByteArrayOutputStream (1024);

      tidy.parse (urlConnect.getInputStream(), new BufferedOutputStream (stream));
      if ( tidy.getParseErrors() > 0 )
        throw new GeneralRenderingException("Unable to convert input document to XHTML");
      xml = stream.toString();
    }
    else
    {
      String line = null;
      BufferedReader in = new BufferedReader(new InputStreamReader(urlConnect.getInputStream()));
      StringBuffer sbText = new StringBuffer (1024);

      while ((line = in.readLine()) != null)
        sbText.append (line).append ("\n");

      xml = sbText.toString ();
    }
    
    return xml;

  }

  // Sends any cookies in the cookie vector as a request header and stores any
  // incoming cookies in the cookie vector
  private void sendAndStoreCookies(URLConnection urlConnect) throws ParseException
  {
    // pass any cookies to the channel that have been stored in the cookie vector
    if (cookies.size() > 0)
    {
      String cookieValue = "";
      Cookie cookie;
      for (int index=0; index<cookies.size(); index++)
      {
         cookie = (Cookie) cookies.elementAt(index);
         cookieValue = cookieValue + cookie.getName() + "=" +cookie.getValue();
         if (index+1 < cookies.size())
            cookieValue = cookieValue + ";";
      }
      urlConnect.setRequestProperty("Cookie", cookieValue);
      // Logger.log(Logger.DEBUG, "CWebProxy: sending the following header: \"Cookie:"+cookieValue+"\"");
    }

    // store any cookies sent by the channel in the cookie vector
    int index = 1;
    String header;
    URL url = urlConnect.getURL();
    String domain = url.getHost();
    String p = url.getPath();
    String path = p.substring(0, p.lastIndexOf("/"));
    while ( (header=urlConnect.getHeaderFieldKey(index)) != null )
    {
       if (supportSetCookie2) 
       {
         if (header.equalsIgnoreCase("set-cookie2"))
         {
            //send Cookie2 header
            urlConnect.setRequestProperty("Cookie2", "Version=\"$1\"");
            processSetCookie2Header(urlConnect.getHeaderField(index), domain, path);           
         }
       }
       else
       {
         if (header.equalsIgnoreCase("set-cookie2"))
         {
           supportSetCookie2 = true;
           processSetCookie2Header(urlConnect.getHeaderField(index), domain, path);
         }
         else if (header.equalsIgnoreCase("set-cookie"))
         {
           processSetCookieHeader(urlConnect.getHeaderField(index), domain, path);
         }
       }
       index++;
    }
  }

  private void processSetCookie2Header (String headerVal, String domain, String path)
  {
     StringTokenizer headerValue = new StringTokenizer(headerVal, ",");
     StringTokenizer cookieValue;
     Cookie cookie;
     String token;
     while (headerValue.hasMoreTokens())
     {
       cookieValue = new StringTokenizer(headerValue.nextToken(), ";");
       token = cookieValue.nextToken(); 
       if ( token.indexOf("=") != -1)
       {
          cookie = new Cookie ( token.substring(0, token.indexOf("=")),
                                token.substring(token.indexOf("=")+1).trim() );
       }  
       else
       {
          Logger.log(Logger.DEBUG, "CWebProxy: Invalid Header: \"Set-Cookie2:"+headerVal+"\"");
          cookie = null;
       }
       // set max-age, path and domain of cookie
       if (cookie != null)
       {
          boolean ageSet = false;
          boolean domainSet = false;
          boolean pathSet = false;
          while( cookieValue.hasMoreTokens() )
          {
            token = cookieValue.nextToken();
            if ( (!ageSet && (token.indexOf("=")!=-1)) && token.substring(0, token.indexOf("=")).trim().equalsIgnoreCase("max-age") )
            {
               cookie.setMaxAge(Integer.parseInt(token.substring(token.indexOf("=")+1).trim()) );
               ageSet = true;
            }
            if ( (!domainSet && (token.indexOf("=")!=-1)) && token.substring(0, token.indexOf("=")).trim().equalsIgnoreCase("domain") )
            {
               cookie.setDomain(token.substring(token.indexOf("=")+1).trim()); 
               domainSet = true;
            }
            if ( (!pathSet && (token.indexOf("=")!=-1)) && token.substring(0, token.indexOf("=")).trim().equalsIgnoreCase("path") )
            {
               cookie.setPath(token.substring(token.indexOf("=")+1).trim());
               pathSet = true;
            }
          }
          if (!domainSet)
          {
             cookie.setDomain(domain);    
          }
          if (!pathSet)
          {
             cookie.setPath(path); 
          }
          // checks to see if this cookie should replace one already stored
          for (int index = 0; index < cookies.size(); index++)
          {
             Cookie old = (Cookie) cookies.elementAt(index);
             if ( cookie.getName().equals(old.getName()) ) 
             {
                String newPath = cookie.getPath();
                String newDomain = cookie.getDomain();
                String oldPath = old.getPath();
                String oldDomain = old.getDomain();
                if (newDomain.equalsIgnoreCase(oldDomain) && newPath.equals(oldPath))
                     cookies.removeElement(old);
             }
          }
          // handles the max-age cookie attribute (according to rfc 2965)
          int expires = cookie.getMaxAge();
          if (expires < 0)
          {
            // cookie persists until browser shutdown so add cookie to
            // cookie vector, no need to set timer
            cookies.addElement(cookie);
          }
          else if (expires == 0)
          {
            // cookie is to be discarded immediately, do not store
          }
          else
          {
            // add the cookie to the cookie vector and then
            // set a timer that will remove the cookie from the vector
            // when the max-age has been reached
            cookies.addElement(cookie);
            Date d = new Date();
            timer.schedule( new RemoveCookieTimerTask(cookie), new Date( (long) d.getTime()+(expires*1000)) );
          }
      }
    } 
  }
 
  private void processSetCookieHeader (String headerVal, String domain, String path)    throws ParseException
  {
     StringTokenizer cookieValue;
     String token;
     Cookie cookie;
     if ( ( (headerVal.indexOf("Expires=") != -1)
              || (headerVal.indexOf("expires=") != -1) )
              || (headerVal.indexOf("EXPIRES=") != -1) )
     {
       // there is only one cookie (old netscape spec)
       cookieValue = new StringTokenizer(headerVal, ";");
       token = cookieValue.nextToken();
       if ( token.indexOf("=") != -1)
       {
          cookie = new Cookie ( token.substring(0, token.indexOf("=")),
                                token.substring(token.indexOf("=")+1).trim() );
       }
       else
       {
          Logger.log(Logger.DEBUG, "CWebProxy: Invalid Header: \"Set-Cookie:"+headerVal+"\"");
          cookie = null;
       }
       // set max-age, path and domain of cookie
       if (cookie != null)
       {
         boolean ageSet = false;
         boolean domainSet = false;
         boolean pathSet = false;
         while( cookieValue.hasMoreTokens() )
         {
           token = cookieValue.nextToken();
           if ( (!ageSet && (token.indexOf("=")!=-1)) && token.substring(0, token.indexOf("=")).trim().equalsIgnoreCase("expires") )
           {
              SimpleDateFormat f = new SimpleDateFormat("EEE, d-MMM-yyyy hh:mm:ss z");
              f.setLenient(true);
              Date date = f.parse( token.substring(token.indexOf("=")+1).trim());
              Date current = new Date();
              if (date!=null)
              {
                //set max-age for cookie
                long l;
                if (date.before(current))
                   //accounts for the case where max age is 0 and cookie should
                   //be discarded immediately
                   l = 0;
                else
                   l = date.getTime() - current.getTime();
                int exp = (int) l / 1000;
                cookie.setMaxAge(exp);
                ageSet = true;
              }
           }
           if ( (!domainSet && (token.indexOf("=")!=-1)) && token.substring(0, token.indexOf("=")).trim().equalsIgnoreCase("domain") )
           {
              cookie.setDomain(token.substring(token.indexOf("=")+1).trim());
              domainSet = true;
           }
           if ( (!pathSet && (token.indexOf("=")!=-1)) && token.substring(0, token.indexOf("=")).trim().equalsIgnoreCase("path") )
           {
              cookie.setPath(token.substring(token.indexOf("=")+1).trim());
              pathSet = true;
           }
         }
         if (!domainSet)
         {
            cookie.setDomain(domain);
         }
         if (!pathSet)
         {
            cookie.setPath(path);
         }
         // checks to see if this cookie should replace one already stored
         for (int index = 0; index < cookies.size(); index++)
         {
            Cookie old = (Cookie) cookies.elementAt(index);
            if ( cookie.getName().equals(old.getName()) )
            {
               String newPath = cookie.getPath();
               String newDomain = cookie.getDomain();
               String oldPath = old.getPath();
               String oldDomain = old.getDomain();
               if ( newDomain.equalsIgnoreCase(oldDomain) && newPath.equals(oldPath) )
                  cookies.removeElement(old);
            }
         }
         // handles the max-age cookie attribute (according to rfc 2965)
         int expires = cookie.getMaxAge();
         if (expires < 0)
         {
           // cookie persists until browser shutdown so add cookie to
           // cookie vector, no need to set timer
           cookies.addElement(cookie);
         }
         else if (expires == 0)
         {
           // cookie is to be discarded immediately, do not store
         }
         else
         {
           // add the cookie to the cookie vector and then
           // set a timer that will remove the cookie from the vector
           // when the max-age has been reached
           cookies.addElement(cookie);
           Date d = new Date();
           timer.schedule( new RemoveCookieTimerTask(cookie), new Date( (long) d.getTime()+(expires*1000)) );
         }
       }
     }
     else
     {
       // can treat according to RCF 2965
       processSetCookie2Header(headerVal, domain, path);
     }
  }
 
  // Removes the cookie from the vector of stored cookies when the cookie expires.
  private class RemoveCookieTimerTask extends TimerTask
  {

     Cookie cookie;

     public RemoveCookieTimerTask (Cookie cookie) 
     {
       this.cookie = cookie;
     } 
 
     public void run()
     {
       cookies.removeElement(cookie);   
     }
  }
}
