---
description: Comprehensive system health checkup including disk health, SMART status, filesystem checks, and overall system status
tags: [sysadmin, diagnostics, health, disk, smart, filesystem, comprehensive]
---

Perform a comprehensive system health checkup:

1. **Disk Health (SMART)**: Check all disk SMART status and health indicators
2. **Filesystem Health**: Check all mounted filesystems for errors
3. **System Resources**: CPU, memory, swap, and load status
4. **Critical Services**: Verify critical system services are running
5. **Security Updates**: Check for pending security updates
6. **Disk Space**: Check all mounted filesystems for space issues
7. **System Logs**: Check for recent critical errors
8. **Hardware Errors**: Check for hardware-related issues in logs

Run the following comprehensive diagnostic commands:

**Disk Health (SMART):**
- `sudo smartctl --scan` to identify all drives
- `sudo smartctl -H /dev/sda` for health status (repeat for all drives found)
- `sudo smartctl -A /dev/sda` for SMART attributes (repeat for all drives)
- Check for: Reallocated sectors, Current pending sectors, Offline uncorrectable sectors

**Filesystem Health:**
- `df -h` for disk space on all filesystems
- `sudo btrfs device stats /` if using BTRFS
- Check mounted filesystems with `mount | grep -E '^/dev'`
- For ext4: `sudo tune2fs -l /dev/sdXY | grep -i 'state\|error'` for filesystem state

**System Resources:**
- `free -h` for memory usage
- `uptime` for load averages
- `top -b -n 1 | head -n 20` for process overview
- `swapon --show` for swap status

**Critical Services:**
- `systemctl status systemd-journald` for logging service
- `systemctl status cron` or `systemctl status crond` for task scheduler
- `systemctl --failed` for any failed services

**Updates and Security:**
- `sudo apt-get update` to refresh package lists
- `apt list --upgradable` to check for available updates
- `grep -i security /var/log/apt/history.log | tail -n 20` for recent security updates

**System Logs:**
- `journalctl -p 3 -b` for errors in current boot
- `journalctl -p 2 -b` for critical issues in current boot
- `dmesg | grep -i 'error\|fail\|critical' | tail -n 20` for kernel errors

**Hardware Status:**
- `sensors` for temperature monitoring (if lm-sensors installed)
- `dmesg | grep -i 'hardware error'` for hardware errors
- `lspci -v | grep -i 'error'` for PCIe errors

**Additional Checks:**
- Check for excessive failed login attempts: `sudo grep -i 'failed password' /var/log/auth.log | tail -n 10`
- Check for disk I/O errors: `dmesg | grep -i 'I/O error'`

Analyze all results and provide:

**Summary Report:**
- Overall system health status (Healthy, Warning, Critical)
- Disk health status for each drive
- Filesystem health and space status
- Memory and swap status
- Any failed services or critical errors
- Pending updates (especially security)
- Temperature warnings if applicable
- Specific issues found with severity levels

**Recommendations:**
- Immediate actions needed (if any)
- Preventive maintenance suggestions
- Monitoring recommendations
- Whether a reboot is recommended
- Backup reminders if issues detected

**Priority Issues:**
List any issues in order of urgency:
1. Critical (requires immediate attention)
2. Warning (should be addressed soon)
3. Informational (for awareness)

If smartmontools is not installed, offer to install with `sudo apt-get install smartmontools`.
If lm-sensors is not installed and temperature monitoring is desired, offer to install with `sudo apt-get install lm-sensors`.
