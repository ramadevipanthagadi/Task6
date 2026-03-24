# -----------------------------
# Stage 1: Build the application
# -----------------------------
FROM maven:3.9.3-eclipse-temurin-11 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies (caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code
COPY src ./src

# Build the project (package as jar or war)
RUN mvn clean package -DskipTests

# -----------------------------
# Stage 2: Create runtime image
# -----------------------------
FROM eclipse-temurin:11-jre-alpine

# Set working directory
WORKDIR /app

# Copy the built jar/war from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port
EXPOSE 8080

# Command to run the app
ENTRYPOINT ["java","-jar","app.jar"]
