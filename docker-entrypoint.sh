#!/bin/bash
set -e

# Start SSH server in background
/usr/sbin/sshd -D &

# Give SSH a moment to start
sleep 3

# Start ngrok TCP tunnel on port 22
exec ngrok tcp 22
