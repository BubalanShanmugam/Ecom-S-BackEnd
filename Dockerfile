# ---- Build Stage ----
FROM gradle:7.6-jdk17 AS build
WORKDIR /app
COPY . .
RUN gradle clean build -x test

# ---- Run Stage ----
FROM openjdk:17-jdk-slim
WORKDIR /app
# Copy only the built jar from build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose port 8080 (Spring Boot default)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java","-jar","app.jar"]
