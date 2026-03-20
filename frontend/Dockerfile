FROM node:20-alpine

# Set the working directory
WORKDIR /app

# Copy dependency definitions
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application code
COPY . .

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["npm", "run", "dev"]
