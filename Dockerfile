FROM openjdk:17-jdk-slim

WORKDIR /app

COPY . .

RUN chmod +x ./gradlew

RUN ./gradlew clean build -x test

CMD ["sh", "-c", "java -Dserver.port=$PORT -jar build/libs/*.jar"]
