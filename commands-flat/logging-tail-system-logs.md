# Tail System Logs

You are helping the user monitor system logs in real-time for debugging and system monitoring.

## Task

1. **Follow all system logs:**
   ```bash
   # Follow journal in real-time
   journalctl -f

   # Follow with timestamp
   journalctl -f -o short-precise

   # Follow only errors and above
   journalctl -f -p err
   ```

2. **Follow specific services:**
   ```bash
   # Specific service
   journalctl -u SERVICE_NAME -f

   # Multiple services
   journalctl -u NetworkManager -u systemd-resolved -f

   # Example: Common services to monitor
   journalctl -u sddm -u plasmashell -f  # KDE
   journalctl -u gdm -u gnome-shell -f   # GNOME
   ```

3. **Follow kernel messages:**
   ```bash
   # Kernel ring buffer
   dmesg -w

   # Kernel logs from journal
   journalctl -k -f

   # Specific kernel subsystem (e.g., USB)
   dmesg -w | grep -i usb
   ```

4. **Follow authentication logs:**
   ```bash
   # Auth attempts
   journalctl -u ssh -u sudo -f

   # Login attempts
   journalctl _SYSTEMD_UNIT=systemd-logind.service -f

   # Traditional auth log (if available)
   tail -f /var/log/auth.log
   ```

5. **Follow application logs:**
   ```bash
   # X11 session
   tail -f ~/.xsession-errors

   # Wayland session
   journalctl --user -f

   # Specific application
   journalctl -f | grep -i "application-name"
   ```

6. **Follow with filtering:**
   ```bash
   # Only show errors/warnings
   journalctl -f -p warning

   # Filter by identifier
   journalctl -f -t identifier-name

   # Specific priority range
   journalctl -f -p err..warning

   # Grep for specific terms
   journalctl -f | grep -i "error\|fail\|critical"
   ```

7. **Multi-pane log viewing:**
   ```bash
   # Using tmux to watch multiple logs
   tmux new-session -s logs \; \
     split-window -v \; \
     split-window -h \; \
     select-pane -t 0 \; \
     send-keys 'journalctl -f -p err' C-m \; \
     select-pane -t 1 \; \
     send-keys 'dmesg -w' C-m \; \
     select-pane -t 2 \; \
     send-keys 'journalctl -u NetworkManager -f' C-m
   ```

8. **Follow with context:**
   ```bash
   # Last 100 lines plus new
   journalctl -n 100 -f

   # Since specific time
   journalctl --since "10 minutes ago" -f

   # This boot plus new
   journalctl -b -f
   ```

9. **Custom log monitoring script:**
   ```bash
   cat > /tmp/log-monitor.sh << 'EOF'
   #!/bin/bash

   # Colors
   RED='\033[0;31m'
   YELLOW='\033[1;33m'
   NC='\033[0m' # No Color

   echo "Monitoring system logs for critical events..."
   echo "Press Ctrl+C to stop"
   echo ""

   journalctl -f -o short-precise -p warning | while read line; do
     if echo "$line" | grep -qi "error\|fail\|critical"; then
       echo -e "${RED}$line${NC}"
     elif echo "$line" | grep -qi "warning\|warn"; then
       echo -e "${YELLOW}$line${NC}"
     else
       echo "$line"
     fi
   done
   EOF

   chmod +x /tmp/log-monitor.sh
   /tmp/log-monitor.sh
   ```

10. **Interactive log browser:**
    ```bash
    # Use journalctl with cursor navigation
    journalctl --no-pager -n 1000 | less +G

    # Or use GUI log viewer
    ksystemlog  # KDE
    gnome-logs  # GNOME
    ```

## Common Monitoring Scenarios

**Debugging boot issues:**
```bash
# Watch boot process (from another TTY or SSH)
journalctl -b -f
```

**Network troubleshooting:**
```bash
journalctl -u NetworkManager -u systemd-resolved -u wpa_supplicant -f
```

**Display/GPU issues:**
```bash
journalctl -f | grep -iE "drm|amdgpu|nvidia|wayland|xorg"
```

**USB device debugging:**
```bash
dmesg -w | grep -i usb
```

**Bluetooth issues:**
```bash
journalctl -u bluetooth -f
```

**Audio problems:**
```bash
journalctl --user -u pipewire -u wireplumber -f
```

**Package installation monitoring:**
```bash
journalctl -u apt-daily -u apt-daily-upgrade -f
```

## Log Rotation & Management

```bash
# Check journal size
journalctl --disk-usage

# Vacuum old logs
sudo journalctl --vacuum-time=7d
sudo journalctl --vacuum-size=500M

# View available boots
journalctl --list-boots

# Follow logs from previous boot
journalctl -b -1 -f
```

## Alternative Log Files

Some systems still use traditional log files:
```bash
# System log
tail -f /var/log/syslog

# Kernel log
tail -f /var/log/kern.log

# Authentication
tail -f /var/log/auth.log

# Package management
tail -f /var/log/dpkg.log
tail -f /var/log/apt/history.log

# X11
tail -f /var/log/Xorg.0.log
```

## Troubleshooting

**Journal not persistent:**
- Check `/var/log/journal/` exists
- Run: `sudo mkdir -p /var/log/journal && sudo systemctl restart systemd-journald`

**Too much log output:**
- Increase filter priority: `-p err` instead of `-p info`
- Filter by unit: `-u specific-service`
- Use grep to focus on specific issues

**Logs filling disk:**
- Set limit in `/etc/systemd/journald.conf`:
  ```
  SystemMaxUse=500M
  ```
- Restart journald: `sudo systemctl restart systemd-journald`

## Notes

- Use `-o verbose` for maximum detail
- Use `-o json` for machine-readable output
- Use `-o cat` for just the message without metadata
- Ctrl+C to stop following logs
- Consider using `multitail` for advanced multi-log viewing
- Set `--lines=` or `-n` to control how much history to show initially
