# Use OpenJDK image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy source code
COPY . .

# Build the jar
RUN ./mvnw clean package -DskipTests

# Run the jar
CMD ["java", "-jar", "target/myapp-0.0.1-SNAPSHOT.jar"]
