FROM node:trixie

WORKDIR /home/bots/StreamBot

# Cài đặt công cụ build hệ thống và ffmpeg
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    unzip \
    build-essential \
    python3 \
    ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Cài đặt Bun
ENV BUN_INSTALL="/usr/local/"
RUN curl -fsSL https://bun.sh/install | bash

# Copy package.json
COPY package.json package-lock.json* ./

# Dùng npm để cài đặt và biên dịch chính xác các native module C++
RUN npm install

# Copy toàn bộ mã nguồn
COPY . .

EXPOSE 3000
RUN mkdir -p ./videos

# Khởi chạy bot bằng Bun
CMD ["bun", "run", "src/index.ts"]
