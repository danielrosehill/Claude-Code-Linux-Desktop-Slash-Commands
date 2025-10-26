# Monitor System Resources

You are helping the user monitor live system resource usage (CPU, RAM, disk I/O, network).

## Task

1. **Quick resource overview:**
   ```bash
   # System overview
   top -b -n 1 | head -20

   # Better overview with htop (if installed)
   htop

   # Modern alternative: btop
   btop
   ```

2. **CPU monitoring:**
   ```bash
   # CPU usage summary
   mpstat 1 5  # 5 samples, 1 second interval

   # Per-core usage
   mpstat -P ALL 1 5

   # Top CPU consumers
   ps aux --sort=-%cpu | head -10

   # CPU frequency and temperature
   watch -n 1 "grep MHz /proc/cpuinfo | head -20 && sensors"
   ```

3. **Memory monitoring:**
   ```bash
   # Memory usage
   free -h

   # Detailed memory info
   cat /proc/meminfo

   # Top memory consumers
   ps aux --sort=-%mem | head -10

   # Memory usage by process
   smem -tk  # If smem is installed

   # Watch memory usage
   watch -n 1 free -h
   ```

4. **Disk I/O monitoring:**
   ```bash
   # I/O statistics
   iostat -x 1 5

   # Disk usage by device
   iotop -o  # Only show active I/O

   # Per-process I/O
   iotop -P

   # Watch disk I/O
   watch -n 1 "iostat -x | grep -E 'Device|sd|nvme'"
   ```

5. **Network monitoring:**
   ```bash
   # Network interface statistics
   ifstat 1 5

   # Bandwidth per interface
   bmon

   # Network speed
   iftop

   # Connection summary
   ss -s

   # Active connections
   nethogs
   ```

6. **Combined system monitoring:**
   ```bash
   # All-in-one monitoring
   glances

   # Custom dashboard
   watch -n 1 '
   echo "=== CPU ==="
   top -b -n 1 | head -5 | tail -2
   echo ""
   echo "=== Memory ==="
   free -h | grep -E "Mem|Swap"
   echo ""
   echo "=== Disk I/O ==="
   iostat -x 1 1 | grep -E "Device|sd|nvme" | head -5
   echo ""
   echo "=== Network ==="
   ifstat 1 1 | tail -1
   '
   ```

7. **GPU monitoring (AMD):**
   ```bash
   # AMD GPU usage
   radeontop

   # GPU sensors
   watch -n 1 "rocm-smi"

   # Detailed GPU info
   watch -n 1 "rocm-smi --showuse --showmemuse --showtemp"
   ```

8. **Process tree with resource usage:**
   ```bash
   # Process tree
   pstree -p

   # Resource-aware process tree
   ps auxf

   # Find resource hogs
   ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -20
   ```

9. **System load monitoring:**
   ```bash
   # Load average
   uptime

   # Load over time
   watch -n 1 "uptime && cat /proc/loadavg"

   # Who's causing load
   tload -d 1
   ```

10. **Create monitoring script:**
    ```bash
    cat > /tmp/system-monitor.sh << 'EOF'
    #!/bin/bash
    echo "System Resource Monitor - $(date)"
    echo "========================================"
    echo ""
    echo "CPU Usage:"
    mpstat 1 1 | tail -1
    echo ""
    echo "Memory:"
    free -h | grep -E "Mem|Swap"
    echo ""
    echo "Load Average:"
    uptime
    echo ""
    echo "Top 5 CPU Processes:"
    ps aux --sort=-%cpu | head -6 | tail -5
    echo ""
    echo "Top 5 Memory Processes:"
    ps aux --sort=-%mem | head -6 | tail -5
    echo ""
    echo "Disk Usage:"
    df -h / /home
    echo ""
    echo "Disk I/O:"
    iostat -x 1 1 | grep -E "sd|nvme"
    EOF

    chmod +x /tmp/system-monitor.sh
    /tmp/system-monitor.sh
    ```

## Present Summary to User

Provide snapshot of:
- **CPU:** Usage %, load average, top processes
- **Memory:** Used/Free, swap usage, top consumers
- **Disk:** Usage %, I/O wait, active reads/writes
- **Network:** Bandwidth usage, active connections
- **GPU:** Usage % (if applicable)

Flag any concerning patterns:
- High CPU usage (>80% sustained)
- Low memory (<10% free)
- High swap usage
- Disk I/O bottlenecks
- Network saturation

## Install Monitoring Tools if Needed

```bash
# Install commonly needed tools
sudo apt install -y \
    htop \
    btop \
    iotop \
    iftop \
    nethogs \
    glances \
    sysstat \
    bmon \
    radeontop
```

## Troubleshooting High Usage

**High CPU:**
- Identify process: `top` or `htop`
- Check if legitimate (updates, backups, encoding)
- Kill if necessary: `kill -15 PID`

**High Memory:**
- Check for memory leaks: `ps aux --sort=-%mem`
- Clear caches: `sudo sync && sudo sysctl -w vm.drop_caches=3`
- Check for swap thrashing

**High Disk I/O:**
- Identify process: `iotop -o`
- Check if expected (backups, indexing, updates)
- Monitor disk health: `/check-disk-errors`

**High Network:**
- Identify connections: `nethogs` or `iftop`
- Check for unexpected traffic
- Use `ss -tunap` to see connections

## Notes

- Most monitoring tools require sudo for full functionality
- `glances` provides best all-in-one view
- `btop` is modern, colorful alternative to `htop`
- Some tools need to be installed separately
- For persistent monitoring, consider setting up Prometheus/Grafana
- Check `systemd-cgtop` for cgroup resource usage
