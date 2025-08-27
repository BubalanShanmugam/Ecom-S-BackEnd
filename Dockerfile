
# ---- Build Stage ----
FROM gradle:8.5-jdk17 AS build

# Set working directory
WORKDIR /app

# Copy everything into the container
COPY . .

# Make gradlew executable
RUN chmod +x ./gradlew

# Run build (skip tests to save time)
RUN ./gradlew clean build -x test

# ---- Run Stage ----
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy built jar from build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
