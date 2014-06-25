/opt/apache-tomcat-7.0.54/bin/shutdown.sh
ant -Dmaven.test.skip=true deploy-war
/opt/apache-tomcat-7.0.54/bin/startup.sh
