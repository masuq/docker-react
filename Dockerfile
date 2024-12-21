FROM node:alpine AS builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx
# Update the package list and install net-tools check 
RUN apt-get update && apt-get install -y net-tools

# Clean up to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose the default Nginx port
EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html
