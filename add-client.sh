#!/bin/bash
# ------------------------------------------------------------------
# Digital Sovereignty Stack - WireGuard Client Generator
# ------------------------------------------------------------------

# Configuration
SERVER_WG_IP="10.0.0.1"
SERVER_PUBLIC_KEY="YOUR_SERVER_PUBLIC_KEY_HERE"
SERVER_ENDPOINT="yourdomain.com:51820"
CLIENTS_DIR="./clients"

mkdir -p $CLIENTS_DIR

echo "--- Client Configuration Generator ---"
read -p "Enter Client Name (e.g., Beryl-USA): " CLIENT_NAME

# Generate Keys
PRIVATE_KEY=$(wg genkey)
PUBLIC_KEY=$(echo $PRIVATE_KEY | wg pubkey)
PRESHARED_KEY=$(wg genpsk)

# Get last assigned IP (Simple increment logic)
# Default to 10.0.0.2 if no clients exist
LAST_IP=$(ls $CLIENTS_DIR/*.conf 2>/dev/null | wc -l)
CLIENT_IP="10.0.0.$((LAST_IP + 2))"

# Create Client Config
cat <<EOF > $CLIENTS_DIR/$CLIENT_NAME.conf
[Interface]
PrivateKey = $PRIVATE_KEY
Address = $CLIENT_IP/32
DNS = $SERVER_WG_IP
MTU = 1320

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
PresharedKey = $PRESHARED_KEY
Endpoint = $SERVER_ENDPOINT
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
EOF

echo "------------------------------------------------"
echo "DONE! Configuration saved: $CLIENTS_DIR/$CLIENT_NAME.conf"
echo "Client IP: $CLIENT_IP"
echo "------------------------------------------------"

# Display QR Code if qrencode is installed
if command -v qrencode &> /dev/null; then
    echo "Scan this QR Code with your mobile app:"
    qrencode -t ansiutf8 < $CLIENTS_DIR/$CLIENT_NAME.conf
fi
