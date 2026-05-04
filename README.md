# 🌐 The Digital Sovereignty Stack
### A-Z Guide: Private VPN, Network-Wide Ad-Blocking, and Global Exit Nodes

This repository contains the blueprint for a high-performance, self-hosted networking stack. It is designed to maintain privacy, block advertisements, and ensure internet access even under the most restrictive network conditions (DPI, Firewalling, Censorship).

---

## 🏗️ System Architecture

* **The Server:** A low-power Always-On device (Raspberry Pi, Mini PC, or NUC) located at **Home Base (Location A)**.
* **Primary Tunnel:** **WireGuard** for high-speed, encrypted entry to your network.
* **The Bouncer:** **Pi-hole** acting as a network-wide filter for ads and trackers.
* **The Shield:** **Mullvad VPN** (Optional) as a global exit node for anonymity.
* **The Emergency Exit:** **MasterDnsVPN** (DNS Tunneling) for bypassing strict firewalls.

---

## 🛠️ Phase 1: Quick Server Setup (Location A)

The fastest way to deploy the entire stack on a fresh Ubuntu/Debian server is to use the provided automation script.

### 1. Automated Installation
Run these commands to install Docker, create necessary directories, and launch all services:

```bash
git clone https://github.com/libertariancore/-The-Digital-Sovereignty-Stack.git
cd -The-Digital-Sovereignty-Stack
chmod +x setup.sh
./setup.sh
```

### 2. Manual Deployment (Alternative)
If you prefer to run the stack manually via Docker Compose:

```bash
sudo docker-compose up -d
```

---

## 🔧 Phase 2: Maintenance & Client Management

To add new devices (Laptops, Phones, or Travel Routers) to your private network, use the included maintenance script:

```bash
chmod +x add-client.sh
./add-client.sh
```

*This script generates WireGuard configurations with optimized MTU settings for international roaming and displays a QR code for mobile devices.*

---

## 🆘 Phase 3: Emergency Backup (MasterDnsVPN)

When standard VPN protocols (Wireguard/OpenVPN) are blocked by Deep Packet Inspection (DPI) in restrictive regions, use the **DNS Tunneling** bridge.

### 1. How it works
This component disguises your data as standard DNS queries. It is slower than Wireguard but nearly impossible to block without shutting down the entire network's DNS system.

### 2. Configuration
* **Server Side:** Set up an NS Record at your domain provider pointing a subdomain (e.g., v.yourdomain.com) to your Home Base IP.
* **Client Side:** Run the MasterDnsVPN client on your laptop/mobile and point it to your delegated subdomain.
* **Proxy:** Connect your browser to the local SOCKS5 proxy (default: 127.0.0.1:18000).

---

## 🛡️ Phase 4: Privacy & Filtering Layer

To ensure your Home Base IP remains hidden and your traffic remains clean:
* **Content Filtering:** This stack uses **Pi-hole** by default. For users with an **AdGuard Family** license, you can alternatively point your DNS settings to AdGuard for advanced cosmetic filtering.
* **Mullvad Integration:** Configure the server to route outbound traffic through Mullvad for total anonymity.
* **Interface Binding:** Bind specific applications to the VPN interface (tun0) to act as a hardware-level Kill Switch.

---

## ✈️ Phase 5: Mobility & Global Access (Location B)

### 1. Handling Dynamic IPs (DDNS)
Use a DDNS provider (like DuckDNS) to ensure your mobile devices can always find your home server if your ISP changes your IP address.

### 2. The Traveler Setup
For the best experience, use a travel router (e.g., **GL.iNet Beryl AX / Beryl 7**).
* **Advanced Integration Guide:** See our Beryl 7 Specific Instructions for hardware switch mapping and MTU optimization.
* **Normal Mode:** Connects to Home Base via Wireguard.
* **Emergency Mode:** If Wireguard is blocked, switch the router's exit node to the MasterDnsVPN bridge.

---

## 📜 Legal & Licensing

* **Pi-hole:** Managed under the EUPL v1.2.
* **MasterDnsVPN:** Included under the **MIT License** (Copyright (c) 2026 Amin Mahmoudi).
* **Wireguard:** Managed under the GPL v2.

**Disclaimer:** *This stack is for educational and research purposes only. Users are responsible for complying with local laws and regulations.*
