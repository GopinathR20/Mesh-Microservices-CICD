# Stage 1: Build the application using Maven
FROM maven:3.8.5-openjdk-17 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create the final, lightweight container image
# FIX: Use the correct, maintained Alpine-based tag for JRE 17
FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

# Final Fix: EXPOSE must be on its own line without inline comments
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]