# Build stage
FROM gradle:7.6-jdk17 AS builder

# Set working directory
WORKDIR /app

# Copy the entire project
COPY . .

# Make gradlew executable and build
RUN chmod +x ./gradlew
RUN ./gradlew clean build -x test --no-daemon

# Run stage
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy the built JAR from builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
