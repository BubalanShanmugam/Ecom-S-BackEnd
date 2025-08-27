# Use OpenJDK image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy source code
COPY . .

# Build the jar
RUN ./gradlew build

# Run the jar
CMD ["java", "-jar", "e-commerce-0.0.1-SNAPSHOT.jar"]

