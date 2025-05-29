# Use a lean Node.js base image
FROM node:16-alpine # Or node:20-alpine for smaller size if compatible

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (if you use it)
# to install dependencies
COPY package.json ./
COPY package-lock.json ./

# Install dependencies (only production dependencies)
RUN npm ci --only=production # `npm ci` is faster and more reliable in CI/CD

# Copy the rest of your action's code
COPY index.js ./

# Define the entry point for your action
# CMD ["node", "index.js"] # or use ENTRYPOINT
ENTRYPOINT ["node", "index.js"]