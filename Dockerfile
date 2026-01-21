FROM tomcat:9.0

COPY dist/svs.war /usr/local/tomcat/webapps/svs.war

EXPOSE 8080
