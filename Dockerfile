# Build stage
FROM gradle:7.6-jdk17 AS builder

# Set working directory
WORKDIR /app

# Copy gradle files first
COPY gradle gradle
COPY gradlew build.gradle settings.gradle ./

# # Make gradlew executable
# RUN chmod +x ./gradlew
#
# # Download dependencies first (this layer can be cached)
# RUN ./gradlew dependencies --no-daemon


COPY . .
RUN chmod +x ./gradlew
RUN ./gradlew bootJar -x test --no-daemon



# Copy the source code
COPY src src

# Run the build with detailed output
RUN ./gradlew clean build -x test --stacktrace --info --no-daemon

# Run stage
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy the built JAR from builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
# # FROM openjdk:17-jdk-slim
# # WORKDIR /app
# # # Copy only the built jar from build stage
# # COPY --from=build /app/build/libs/*.jar app.jar
# #
# # # Expose port 8080 (Spring Boot default)
# # EXPOSE 8080
# #
# # # Run the application
# # ENTRYPOINT ["java","-jar","app.jar"]


# # # ---- Build Stage ----
# # FROM gradle:7.6-jdk17 AS build
# # WORKDIR /app
# # COPY . .
# # RUN gradle clean build -x test
# #
# # # ---- Run Stage ----
# # FROM openjdk:17-jdk-slim
# # WORKDIR /app
# # COPY --from=build /app/build/libs/*.jar app.jar
# # EXPOSE 8080
# # ENTRYPOINT ["java","-jar","app.jar"]





# # # ---- Build Stage ----
# # FROM openjdk:17-jdk-slim AS build
# # WORKDIR /app
# # COPY . .
# # # Make gradlew executable (important step!)
# # RUN chmod +x ./gradlew
# # RUN ./gradlew clean build -x test
# #
# # # ---- Run Stage ----
# # FROM openjdk:17-jdk-slim
# # WORKDIR /app
# # COPY --from=build /app/build/libs/*.jar app.jar
# # EXPOSE 8080
# # ENTRYPOINT ["java","-jar","app.jar"]



# # ---- Build Stage ----
# FROM gradle:8.5-jdk17 AS build

# # Set working directory
# WORKDIR /app

# # Copy everything into the container
# COPY . .

# # Make gradlew executable
# RUN chmod +x ./gradlew

# # Run build (skip tests to save time)
# RUN ./gradlew clean build -x test

# # ---- Run Stage ----
# FROM openjdk:17-jdk-slim

# WORKDIR /app

# # Copy built jar from build stage
# COPY --from=build /app/build/libs/*.jar app.jar

# # Run the app
# ENTRYPOINT ["java", "-jar", "app.jar"]
