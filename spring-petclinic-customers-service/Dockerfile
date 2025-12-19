FROM eclipse-temurin:17-jre
WORKDIR /app
COPY target/spring-petclinic-customers-service-3.4.1.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java","-jar","app.jar"]
