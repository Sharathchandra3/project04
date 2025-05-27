# Use the official Nginx image from Docker Hub
FROM nginx:alpine

# Remove the default nginx static content
RUN rm -rf /usr/share/nginx/html/*

# Copy our custom index.html to the nginx web root
COPY index.html /usr/share/nginx/html/

# Expose port 80 (standard HTTP port)
EXPOSE 80

# Start nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]
