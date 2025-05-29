FROM node:24-alpine
# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (if you use it)
# to install dependencies
COPY package.json ./
COPY package-lock.json ./

# Install dependencies (only production dependencies)
RUN npm ci --only=production

# Copy the rest of your action's code
COPY index.js ./

# Define the entry point for your action
ENTRYPOINT ["node", "/app/index.js"]