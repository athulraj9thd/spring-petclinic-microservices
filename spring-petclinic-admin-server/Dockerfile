FROM eclipse-temurin:17-jre
WORKDIR /app
COPY target/spring-petclinic-admin-server-3.4.1.jar app.jar
EXPOSE 9090
ENTRYPOINT ["java","-jar","app.jar"]
