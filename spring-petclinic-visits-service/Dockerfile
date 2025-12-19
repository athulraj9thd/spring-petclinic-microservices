FROM eclipse-temurin:17-jre
WORKDIR /app
COPY target/spring-petclinic-visits-service-3.4.1.jar app.jar
EXPOSE 8083
ENTRYPOINT ["java","-jar","app.jar"]
