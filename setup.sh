#!/bin/bash

echo "🚀 Starting Digital Sovereignty Stack Installation..."

# 1. Update and install Docker
sudo apt update && sudo apt upgrade -y
sudo apt install docker.io docker-compose -y

# 2. Enable Docker service
sudo systemctl enable --now docker

# 3. Create necessary folders
mkdir -p masterdns
mkdir -p etc-pihole

# 4. Launch the stack
echo "📦 Launching containers..."
sudo docker-compose up -d

echo "✅ Setup complete! Pi-hole is at http://localhost/admin"
echo "⚠️ Don't forget to configure your DDNS and Port Forwarding (51820 UDP and 53 UDP)."
