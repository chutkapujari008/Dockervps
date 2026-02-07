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

# Install ngrok v3
RUN curl -s https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -o /tmp/ngrok.tgz && \
    tar xvzf /tmp/ngrok.tgz -C /tmp && \
    mv /tmp/ngrok /usr/local/bin/ngrok && \
    chmod +x /usr/local/bin/ngrok && \
    rm /tmp/ngrok.tgz

# FIXED YAML: Correct v3 format with agent.authtoken
RUN mkdir -p /root/.config/ngrok && \
    cat > /root/.config/ngrok/ngrok.yml << EOF
version: 3
agent:
  authtoken: 39K6yZk2YaMCOrSoX0QCf9Dm3MP_2viXDNWmxXVqs1B8McATc
EOF

EXPOSE 22

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
