FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y openssh-server curl ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# SSH setup
RUN mkdir -p /var/run/sshd && \
    echo "root:IPxKINGYT0@a" | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Download and install ngrok (stable version)
RUN curl -s https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -o /tmp/ngrok.tgz && \
    tar xvzf /tmp/ngrok.tgz -C /tmp && \
    mv /tmp/ngrok /usr/local/bin/ngrok && \
    chmod +x /usr/local/bin/ngrok && \
    rm /tmp/ngrok.tgz

# FIXED: Correct ngrok config path + version for v3
RUN mkdir -p /root/.config/ngrok && \
    echo "version: 3" > /root/.config/ngrok/ngrok.yml && \
    echo "authtoken: 39K6yZk2YaMCOrSoX0QCf9Dm3MP_2viXDNWmxXVqs1B8McATc" >> /root/.config/ngrok/ngrok.yml

EXPOSE 22

# Entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
