# Use Debian (trixie) as the base image
FROM node:trixie

# Set the working directory
WORKDIR /home/bots/StreamBot

# Install minimal dependencies, build tools, python3, and ffmpeg
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    unzip \
    build-essential \
    python3 \
    ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install bun and add to PATH
ENV BUN_INSTALL="/usr/local/"
RUN curl -fsSL https://bun.sh/install | bash

# Copy package.json and lock file
COPY package.json bun.lock* package-lock.json* ./

# Install dependencies
RUN bun install

# Trust all packages
RUN bun pm trust --all

# Copy the rest of the application code
COPY . .

# Verify the application builds
RUN bun run build

# Specify the port number the container should expose
EXPOSE 3000

# Create videos folder
RUN mkdir -p ./videos

# Command to run the application
CMD ["bun", "run", "start"]
