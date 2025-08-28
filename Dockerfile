# ------------ Build Stage ------------
FROM gradle:8.6-jdk17 AS builder

WORKDIR /app

# Copy settings.gradle from root
COPY settings.gradle ./

# Copy gradle wrapper and build files
COPY gradlew* ./
COPY gradle ./gradle

# Copy build.gradle from e_commerce module
COPY e_commerce/build.gradle ./e_commerce/build.gradle

# Copy source code
COPY e_commerce ./e_commerce

# Build Spring Boot jar (skip tests)
RUN ./gradlew bootJar -x test --no-daemon


# Make gradlew executable inside container
RUN chmod +x ./gradlew

# ------------ Run Stage ------------
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy the built JAR from builder stage
COPY --from=builder /app/e_commerce/build/libs/*.jar app.jar

# Render requires a dynamic port
ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]

