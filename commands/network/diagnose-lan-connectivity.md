---
description: Diagnose LAN connectivity issues by pinging gateway and testing network
tags: [network, diagnostics, connectivity, gateway, troubleshooting, project, gitignored]
---

You are helping the user diagnose LAN connectivity issues.

## Process

1. **Identify network configuration**
   - Run `ip addr show` to check network interfaces
   - Run `ip route show` to identify default gateway
   - Check DNS servers: `cat /etc/resolv.conf`

2. **Test gateway connectivity**
   - Ping default gateway: `ping -c 4 <gateway-ip>`
   - If gateway is unreachable, check:
     - Network interface status: `ip link show`
     - NetworkManager status: `nmcli device status`
     - Physical connection (if applicable)

3. **Test DNS resolution**
   - Test DNS lookup: `nslookup google.com`
   - Try alternative DNS: `nslookup google.com 8.8.8.8`
   - Check if DNS is the issue

4. **Test external connectivity**
   - Ping external IP: `ping -c 4 8.8.8.8`
   - Ping domain name: `ping -c 4 google.com`
   - Traceroute to identify where packets stop: `traceroute google.com`

5. **Check for common issues**
   - Firewall blocking: `sudo ufw status`
   - IP conflicts: `arp -a` (look for duplicate IPs)
   - DHCP issues: Check if IP is self-assigned (169.254.x.x)

6. **Advanced diagnostics**
   - Check routing table: `ip route show`
   - Monitor network traffic: `sudo tcpdump -i <interface> -c 20`
   - Check for packet loss: `mtr <gateway-ip>`

## Output

Provide a diagnostic report showing:
- Network configuration summary
- Gateway reachability status
- DNS resolution status
- External connectivity status
- Identified issues (if any)
- Recommended fixes
