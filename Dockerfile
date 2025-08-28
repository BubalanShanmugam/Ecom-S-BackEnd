# ------------ Build Stage ------------
FROM gradle:7.6-jdk17 AS builder
WORKDIR /app

# Copy project
COPY . .

# Make gradlew executable
RUN chmod +x ./gradlew

# Build the Spring Boot module directly (replace 'backend' with your module name)
RUN ./gradlew :backend:bootJar -x test --no-daemon

# ------------ Run Stage ------------
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy the built JAR from builder stage
COPY --from=builder /app/backend/build/libs/*.jar app.jar

# Expose default Spring Boot port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
