FROM nginx:alpine
  
# Set the working directory to /app  
WORKDIR /app

# Copy the HTML, CSS, and JavaScript files into the container
COPY . /usr/share/nginx/html

# Expose the port that the application will use
EXPOSE 80

# Define the command to run when the container starts
CMD ["nginx", "-g", "daemon off;"]
