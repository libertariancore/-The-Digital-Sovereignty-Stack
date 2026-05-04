#!/bin/bash
# Script pour générer un nouveau client WireGuard
read -p "Nom du client (ex: Beryl-US): " CLIENT_NAME
PRIVATE_KEY=$(wg genkey)
PUBLIC_KEY=$(echo $PRIVATE_KEY | wg pubkey)
PRESHARED_KEY=$(wg genpsk)

# Génération du fichier de config client
cat <<EOF > clients/$CLIENT_NAME.conf
[Interface]
PrivateKey = $PRIVATE_KEY
Address = 10.0.0.2/32  # À incrémenter
DNS = 10.0.0.1         # L'IP de ton Pi-hole sur le tunnel

[Peer]
PublicKey = <SERVER_PUBLIC_KEY>
PresharedKey = $PRESHARED_KEY
Endpoint = <TON_DDNS_OU_IP>:51820
AllowedIPs = 0.0.0.0/0
EOF

echo "Config générée dans clients/$CLIENT_NAME.conf"
# Optionnel: générer un QR Code pour mobile
qrencode -t ansiutf8 < clients/$CLIENT_NAME.conf
