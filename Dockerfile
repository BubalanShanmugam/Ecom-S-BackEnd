# ------------ Build Stage ------------
FROM gradle:8.5-jdk17 AS builder
WORKDIR /app

# Copy Gradle wrapper and settings first
COPY build.gradle settings.gradle gradlew* ./
COPY gradle ./gradle

# Copy the rest of the project
COPY . .

# Make gradlew executable
RUN chmod +x gradlew

# Build Spring Boot jar (skip tests)
RUN ./gradlew bootJar -x test --no-daemon

# ------------ Run Stage ------------
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy jar from builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Run Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]
