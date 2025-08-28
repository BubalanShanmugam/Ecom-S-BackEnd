# ------------ Build Stage ------------
FROM gradle:8.5-jdk17 AS builder

# Set working directory inside container
WORKDIR /app

# Copy only gradle files first (better caching)
COPY build.gradle settings.gradle ./
COPY gradle ./gradle
COPY gradlew ./

# Make gradlew executable
RUN chmod +x gradlew

# Copy the rest of the project
COPY . .

# Build Spring Boot jar (skip tests for faster build)
RUN ./gradlew bootJar -x test --no-daemon

# ------------ Run Stage ------------
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy jar from builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Render uses PORT env variable, so expose it
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-jar", "/app.jar"]
