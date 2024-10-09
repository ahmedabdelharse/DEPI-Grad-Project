# # Stage 1: Build the React app
# FROM node:alpine AS build

# ENV NODE_ENV=production

# # Set working directory
# WORKDIR /app

# # Copy package.json and lock file
# COPY react_app/package*.json /app/

# # Install dependencies (only prod dependencies by setting NODE_ENV)
# # RUN npm install --production
# RUN npm ci --production

# # Copy the rest of the application code
# COPY ./react_app/ .

# # Build the React app
# RUN npm run build

# # Stage 2: Serve the built app
# FROM nginx:alpine

# # Copy the build output from the first stage to NGINX
# COPY --from=build /app/build /usr/share/nginx/html

# # Expose port 80 (default Nginx port)
# EXPOSE 80

# # Start NGINX
# CMD ["nginx", "-g", "daemon off;"]

# Stage 1: Build the React app
FROM node:alpine AS build

# Set environment variable for production
ENV NODE_ENV=production

# Set working directory
WORKDIR /app

# Copy only the package.json and package-lock.json for efficient layer caching
COPY react_app/package.json react_app/package-lock.json /app/

# Install only production dependencies using npm ci for a clean install
RUN npm cache clean --force && npm ci --production

# Copy the rest of the application code
COPY ./react_app/ .

# Run tests before the build
RUN npm run test

# Build the React app for production
RUN npm run build

# Stage 2: Serve the app with NGINX
FROM nginx:alpine

# Copy the production build output from the first stage to NGINX
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 to allow access to the app
EXPOSE 80

# Start the NGINX server
CMD ["nginx", "-g", "daemon off;"]
