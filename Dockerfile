# Stage 1: Build the React app
FROM node:alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and lock file
COPY package.json package-lock.json /app/

# Install dependencies (only prod dependencies by setting NODE_ENV)
# RUN npm install --production
RUN npm ci --production

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Stage 2: Serve the built app
FROM nginx:alpine

# Copy the build output from the first stage to NGINX
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 (default Nginx port)
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
