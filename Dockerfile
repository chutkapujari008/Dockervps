# Base image (minimal Debian)
FROM debian:bookworm-slim

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install OpenSSH server and curl
RUN apt-get update && \
    apt-get install -y openssh-server curl ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create SSH run directory
RUN mkdir -p /var/run/sshd

# Set root password
RUN echo "root:IPxKINGYT0@a" | chpasswd

# Allow root login with password
RUN sed -i 's/#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Download and install ngrok (latest release)
RUN curl -LO https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip && \
    mkdir -p /usr/local/bin && \
    unzip ngrok-v3-stable-linux-amd64.zip -d /usr/local/bin && \
    rm ngrok-v3-stable-linux-amd64.zip

# Set ngrok authtoken (hardcoded for your Railway deployment)
RUN echo "authtoken: 39K6yZk2YaMCOrSoX0QCf9Dm3MP_2viXDNWmxXVqs1B8McATc" | \
    tee /root/.config/ngrok/ngrok.yml

# Expose SSH port (tunnel will be TCP 22)
EXPOSE 22

# Create entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Start SSH and ngrok
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
