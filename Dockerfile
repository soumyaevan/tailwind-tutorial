# Multi-stage build for Tailwind CSS application

# Stage 1: Build stage
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source files
COPY src/ ./src/
COPY . .

# Build Tailwind CSS
RUN npm run tw:build

# Stage 2: Production stage with Nginx
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy built files from builder stage
COPY --from=builder /app/src/index.html /usr/share/nginx/html/
COPY --from=builder /app/src/assets/ /usr/share/nginx/html/assets/
COPY --from=builder /app/dist/output.css /usr/share/nginx/html/dist/output.css

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
