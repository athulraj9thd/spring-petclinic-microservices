FROM eclipse-temurin:17-jre
WORKDIR /app
COPY target/spring-petclinic-api-gateway-3.4.1.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
