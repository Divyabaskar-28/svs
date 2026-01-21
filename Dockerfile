FROM tomcat:9.0

COPY dist/SVS.war /usr/local/tomcat/webapps/SVS.war

EXPOSE 8080

