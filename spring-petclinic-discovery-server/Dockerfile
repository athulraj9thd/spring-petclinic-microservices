FROM eclipse-temurin:17-jre
WORKDIR /app
COPY target/spring-petclinic-discovery-server-3.4.1.jar app.jar
EXPOSE 8761
ENTRYPOINT ["java","-jar","app.jar"]
