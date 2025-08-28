# ------------ Build Stage ------------
FROM gradle:8.6-jdk17 AS builder

WORKDIR /app

# Copy Gradle wrapper and build files first (for caching)
COPY build.gradle settings.gradle gradlew* ./
COPY gradle ./gradle

# Download dependencies (cache layer)
RUN ./gradlew dependencies --no-daemon || true

# Copy full source code
COPY . .

# Build Spring Boot jar (skip tests)
RUN ./gradlew bootJar -x test --no-daemon

# ------------ Run Stage ------------
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy only the jar file from builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Render requires a dynamic port ($PORT)
ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
