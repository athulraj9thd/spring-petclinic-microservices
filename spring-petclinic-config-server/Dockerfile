FROM eclipse-temurin:17-jre

WORKDIR /app

COPY target/spring-petclinic-config-server-3.4.1.jar app.jar

EXPOSE 8888

ENTRYPOINT ["java","-jar","app.jar"]
