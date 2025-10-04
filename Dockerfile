# Multi-stage build for kholles-manager

# Stage 1: Build CSS with Tailwind
FROM node:20-alpine AS css-build

WORKDIR /app/node

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy package files
COPY src/main/node/package.json src/main/node/pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy CSS source
COPY src/main/node/style.css ./

# Copy JTE templates (needed for Tailwind to scan for CSS classes)
COPY src/main/jte ../jte

# Create output directory
RUN mkdir -p ../resources/static

# Build Tailwind CSS
RUN pnpm run build

# Stage 2: Build the application
FROM gradle:8.14.3-jdk21-alpine AS build

WORKDIR /app

# Copy Gradle wrapper and dependencies
COPY gradle gradle
COPY gradlew ./
COPY build.gradle.kts settings.gradle.kts ./
COPY lombok.config ./

# Make gradlew executable
RUN chmod +x gradlew

# Download dependencies (this layer will be cached)
RUN ./gradlew dependencies --no-daemon || true

# Copy source code
COPY src src

# Copy compiled CSS from css-build stage
COPY --from=css-build /app/resources/static/main.css src/main/resources/static/main.css

# Build the application
RUN ./gradlew bootJar --no-daemon -x test

# Stage 3: Runtime image
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Create a non-root user
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copy the built JAR from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Environment variables that MUST be set at runtime
ENV ADMIN_PASSWORD=""

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
