# 🌐 The Digital Sovereignty Stack
### A-Z Guide: Private VPN, Network-Wide Ad-Blocking, and Global Exit Nodes
This repository contains the blueprint for a high-performance, self-hosted networking stack. It allows you to maintain privacy, block advertisements at the DNS level, and access your home network securely from anywhere in the world.
## 🏗️ System Architecture
 * **The Server:** A low-power Always-On device (Raspberry Pi, Mini PC, or NUC) located at **Home Base (Location A)**.
 * **The Tunnel:** A **WireGuard** or **OpenVPN** connection providing secure entry to your network.
 * **The Filter:** **Pi-hole** or **AdGuard Home** acting as a network bouncer to drop ads and trackers.
 * **The Encryption:** **DNSCrypt-Proxy** to prevent your ISP from logging your DNS queries.
 * **The Exit:** An optional secondary node at **Remote Base (Location B)** to bypass geographical restrictions.
## 🛠️ Phase 1: Server Setup (Location A)
*Recommended OS: Ubuntu Server, Debian, or any lightweight Linux distro.*
### 1. Prerequisite: Docker & Compose
Using Docker ensures your setup is modular and easy to back up or migrate.
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install docker.io docker-compose -y

```
### 2. Deployment
Create a docker-compose.yml file:
```yaml
version: "3"
services:
  # DNS Filtering (Ad-Blocking)
  pihole:
    image: pihole/pihole:latest
    container_name: pihole
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "80:80/tcp"
    environment:
      - TZ=UTC
      - WEBPASSWORD=SetYourAdminPassword
    volumes:
      - './etc-pihole:/etc/pihole'
    restart: unless-stopped

  # Secure VPN Access
  wireguard:
    image: linuxserver/wireguard:latest
    container_name: wireguard
    cap_add:
      - NET_ADMIN
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=UTC
      - SERVERURL=your.ddns.address # Use a Dynamic DNS provider
      - SERVERPORT=51820
      - PEERS=mobile,laptop,travelrouter
      - PEERDNS=172.17.0.1 # Directs VPN traffic through Pi-hole
    ports:
      - "51820:51820/udp"
    restart: unless-stopped

```
## 🛡️ Phase 2: Privacy & Anonymity Layer
To hide your "Home Base" IP during sensitive activities (e.g., P2P/Torrents):
 1. **VPN Exit Node:** Configure your server to route specific outbound traffic through a commercial privacy-focused VPN (e.g., Mullvad or IVPN).
 2. **Interface Binding:** If running a torrent client, bind the application to the VPN network interface (usually tun0 or wg0). This acts as a hardware-level **Kill Switch**.
 3. **DNSCrypt:** Route Pi-hole's "Upstream DNS" to a DNSCrypt-Proxy container to ensure your requests are encrypted before they leave the server.
## ✈️ Phase 3: Mobility & Global Access
### 1. Handling Dynamic IPs (DDNS)
Residential internet usually changes your public IP periodically.
 * Use a **Dynamic DNS (DDNS)** service (e.g., DuckDNS, No-IP) to map your home network to a domain name (e.g., myhome.duckdns.org).
 * Configure your VPN clients to point to this domain rather than a static IP.
### 2. The "Traveler" Setup
For maximum ease of use, use a **Travel Router** as your primary mobile client.
 * Connect the Travel Router to the local Wi-Fi (Hotel, Cafe, Airport).
 * The Router establishes one single WireGuard connection back to **Location A**.
 * All your devices (Phone, Laptop, Tablet) connect to the Travel Router and are automatically protected without individual configuration.
## 🌍 Phase 4: Bypassing Geo-Restrictions (Location B)
If you need to appear as if you are in a different country (e.g., for banking or local streaming):
 1. Deploy a lightweight VPN server (WireGuard) at **Location B** (a friend's house or a cloud VPS).
 2. Add **Location B** as an "Exit Node" option in your Travel Router or VPN client.
 3. Toggle between **Location A** (Standard browsing) and **Location B** (Geo-specific access) as needed.
## 📜 Maintenance Checklist
 * **Security:** Use UFW (Uncomplicated Firewall) to close all ports except the one used by your VPN.
 * **Updates:** Set up a "Watchtower" container to automatically update your Docker images.
 * **Redundancy:** Install **Tailscale** or **ZeroTier** as a backup "backdoor" in case your primary WireGuard configuration fails during a move or ISP change.
*This guide is provided for educational purposes to help users reclaim their digital sovereignty.*
