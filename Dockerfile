FROM node:22-slim

WORKDIR /app

COPY index.js index.html package.json start.sh ./

EXPOSE 3000/tcp

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssl curl ca-certificates openssh-server iproute2 coreutils bash && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /run/sshd && \
    ssh-keygen -A && \
    chmod +x index.js start.sh && \
    npm install --omit=dev

CMD ["./start.sh"]
