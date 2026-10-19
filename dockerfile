FROM maven:3.8.5-openjdk-17-slim AS builder
WORKDIR /java-app
COPY pom.xml ./
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn package -DskipTests

#runtime

 FROM eclipse-temurin:17-jre-alpine
 RUN addgroup -S appgroup && adduser -S appuser -G appgroup
 WORKDIR /app
 COPY --from=builder --chown=appuser:appgroup  /java-app/target/*.jar app.jar
 EXPOSE 8081
 USER appuser
 ENTRYPOINT ["java","-jar","app.jar"]
