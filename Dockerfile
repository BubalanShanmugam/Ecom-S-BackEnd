# ------------ Build Stage ------------
FROM gradle:7.6-jdk17 AS builder
WORKDIR /app

# Copy project
COPY . .

# Make gradlew executable
RUN chmod +x ./gradlew

# Detect Spring Boot module and build
RUN MODULE=$(./gradlew tasks --all | grep bootJar | awk '{print $1}' | head -n1 | sed 's/:bootJar//') \
    && echo "Building module: $MODULE" \
    && ./gradlew ":$MODULE:bootJar" -x test --no-daemon

# ------------ Run Stage ------------
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy JAR from builder stage
COPY --from=builder /app/*/build/libs/*.jar app.jar

# Expose default Spring Boot port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
