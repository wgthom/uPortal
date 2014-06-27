# Exploring Grouper for Groups and Permissions in uPortal

The Groups and Permissions (GAPS) subsystem of uPortal is a local to uPortal system for dealing with groups and permissions.  Groups are used to drive a variety of portal behavior and as targets (aka resources) for permission assignments.  While GAPS has served uPortal well over the years it is specific to uPortal and comes with a maintenance burden requiring resources that may be better allocated elsewhere.

Grouper is a groups and permission management system that is designed specifically for that task, but alas was not yet available when GAPS was created.

At the 2014 Apereo Unconference and again at the 2014 Apereo conference the topic of migrated uPortal's group and permissions needs to Grouper and retiring GAPS was discussed. Some of the benefits that may result by adopting Grouper in uPortal are:
* Reduce uPortal code maintenance burden by adopting Grouper and Spring Security or Apache Shiro and removing GAPSs
* Grouper is a more full featured grouper and permission management system
* Schools with Grouper deployed could leverage institution data driven groups and permissions within uPortal.
* uPortal database schema is reduced and simplified

In order to more fully understand the possibilities, difficulties, and potential work involved in adopting Grouper for uPortal this exploration and technical spike solution was developed.  Work to incorporate Grouper Groups via GAP plugin has be previously completed.  This current exploration is about leveraging Groupers permission system.

## Previous Work

Assessment of Grouper and uPortal  (2005)
https://wiki.jasig.org/display/GAP/Grouper

Comparing the uPortal Groups Service and Grouper (2005)
http://lutung.lib.ums.ac.id/arsip/software/sso/CAS/docs/GAP/Comparing+the+uPortal+Groups+Service+and+Grouper.html

Using Grouper for group management in uPortal (2012)
https://spaces.internet2.edu/display/Grouper/Grouper-uPortal

## uPortal Permissions
uPortal permssions model is descriped in the uPortal 4.0 Manual under About Permissions.  https://wiki.jasig.org/display/UPM40/About+uPortal+Permissions

One can map uPortal Permission concepts to Grouper as follows:

| uPortal | Grouper |
| ------- | ------- |
| Principal | Subject |
| Activity | Action |
| Target | Resource |
| Owner | Permission Definition |

A key part of this work is understanding how uPortal defines it's base permission model and translating that to Grouper.

## uPortal Permission Definitions
uPortal defines a number of "default entities" in various sets of XML files in uportal-war/src/main/data/default_entities

For the purposes of this exploration we are mostly concerned with:
* Permission Definitions
** uportal-war/src/main/data/default\_entities/permission\_owner
* Permission Assignments
** uportal-war/src/main/data/default\_entities/permission\_set

## uPortal to Grouper Translation

### Owner to Permission Definition
uPortal Permission System Terminology defines an Owner as a "Permissions category used to organize activities."  Activities are called Actions in Grouper and are organized in Permission Definitions.

uportal-war/src/main/data/default\_entities/permission\_owner\UP\_ERROR\_CHAN.permission-owner.xml provides this permission definition:

```xml
<permission-owner>
    <name>Error Channel</name>
    <fname>UP_ERROR_CHAN</fname>
    <desc>Permissions controlling the rendering of the uPortal error channel</desc>
    <activity>
        <name>View</name>
        <fname>VIEW</fname>
        <desc></desc>
        <targetProvider>errorChannelTargetProvider</targetProvider>
    </activity>
</permission-owner>
```

which we can translation into a Grouper Permission Definition:
![Grouper Error Channel Permission Definition](https://raw.githubusercontent.com/wgthom/uPortal/uportal-grouper/grouper/up_error_chan_permDef.png)

### Permission Set to Permission Assignment


uportal-war/src/main/data/default\_entities/permission\set\Portal\_Developers\_\_VIEW\_\_UP\_ERROR\_CHAN.permission-set.xml provides this permission definition:

```xml
<permission-set script="classpath://org/jasig/portal/io/import-permission_set_v3-1.crn">
  <owner>UP_ERROR_CHAN</owner>
  <principal-type>org.jasig.portal.groups.IEntityGroup</principal-type>
  <principal>
                                                <group>Portal Developers</group>
                                            </principal>
  <activity>VIEW</activity>
  <target permission-type="GRANT">
                                                <literal>DETAILS</literal>
                                            </target>
</permission-set>
```

In order to translate this to a Grouper permission assignment we first have to take care for two other perquisites, namely creating the subject, which in this case is the role Portal Developers, and the target (or resource), which in this case is "DETAILS".

#### Portal Developer Role
![Portal Developer Role](https://raw.githubusercontent.com/wgthom/uPortal/uportal-grouper/grouper/portaldevs.png)

Note the ID is 12.local.16 which is an artifact of how uPortal expects the role to be represented by uPortal [AuthorizationImpl](https://github.com/Jasig/uPortal/blob/master/uportal-war/src/main/java/org/jasig/portal/security/provider/AuthorizationImpl.java#L671)

#### DETAILS resource
Resource in Grouper are represented by Attribute Names available in a given Stem namespace. In this example DETAILS is the Attribute Name (i.e. resource) in the namespace apps:portal:permission:UP\_ERROR\_CHAN.
![DETAILS resource](https://raw.githubusercontent.com/wgthom/uPortal/uportal-grouper/grouper/detailsresource.png)

Once the permission definition, the subject, and the target are defined we can make a permission assignment:
![Error Chan Permission Assignment](https://raw.githubusercontent.com/wgthom/uPortal/uportal-grouper/grouper/errorchannelassign.png)

With this assignment, any person in the Portal Developer role will have the permission to VIEW the DETAILS of the Error Channel.

### uPortal IPermissionStoreImpl and the GrouperClient
With the permissions modeled in grouper the next step is to integrated the [GrouperClient](https://spaces.internet2.edu/display/Grouper/Grouper+Client)

The uPortal parent pom.xml was upgraded to the latest GrouperClient version and a new version grouper.client.properties was added. https://github.com/wgthom/uPortal/commit/bdedd85eaead12d91f9c02f7f516f6f0bde606a1#diff-600376dffeb79835ede4a0b285078036

With the upgrade, some jar exclusions in uportal-war/pom.xml were necessary to get the project to build and run https://github.com/wgthom/uPortal/commit/40229c708fa70cf0466f10133fe0abd44b9a9504.

With this in place a new GrouperClientPermissionStoreImpl was created.  For the purposes of this exploration this file is a copy of the RDBMSPermissionStore that uses the GrouperClient to retrieve permission definitions for the Error Channel from Grouper as can be seen here:

https://github.com/wgthom/uPortal/blob/0d4835acdd7347bdf30d1e79823c0e695528bfb6/uportal-war/src/main/java/org/jasig/portal/security/provider/GrouperClientPermissionStoreImpl.java#L850

The new GrouperClientPermissionStore is introduced via persistenceContext.xml https://github.com/wgthom/uPortal/commit/0d4835acdd7347bdf30d1e79823c0e695528bfb6#diff-782f83fdfb74ac12fbe8fa66e5619ef5

# Issues

## What to do about the compound subject ID "12.local.16"?

uPortal expects in various places to pack and unpack this compound ID. Here are few of them:
* [PermissionListController.getEntityBean](https://github.com/wgthom/uPortal/blob/0d4835acdd7347bdf30d1e79823c0e695528bfb6/uportal-war/src/main/java/org/jasig/portal/security/remoting/PermissionsListController.java#L175)

* [AuthorizationImpl](https://github.com/wgthom/uPortal/blob/0d4835acdd7347bdf30d1e79823c0e695528bfb6/uportal-war/src/main/java/org/jasig/portal/security/provider/AuthorizationImpl.java#L671)











