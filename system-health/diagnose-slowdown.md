# Diagnose System Slowdown

You are helping the user diagnose system laginess and performance issues.

## Your tasks:

1. **Gather initial information:**
   Ask the user:
   - When did the slowdown start?
   - Is it constant or intermittent?
   - What activities trigger it? (startup, specific applications, general use)
   - Any recent changes? (updates, new software, configuration changes)

2. **Check current system load:**
   - System load averages: `uptime`
   - Detailed load info: `w`
   - Number of processes: `ps aux | wc -l`

3. **CPU analysis:**
   - Real-time CPU usage: `top -b -n 1 | head -20`
   - Per-core CPU usage: `mpstat -P ALL 1 1` (if sysstat installed)
   - Top CPU consumers: `ps aux --sort=-%cpu | head -20`
   - CPU frequency and throttling:
     ```bash
     cat /proc/cpuinfo | grep MHz
     sudo cpupower frequency-info  # if available
     ```
   - Check for thermal throttling:
     ```bash
     sensors  # if lm-sensors installed
     cat /sys/class/thermal/thermal_zone*/temp
     ```

4. **Memory analysis:**
   - Memory usage: `free -h`
   - Detailed memory info: `cat /proc/meminfo`
   - Swap usage: `swapon --show`
   - Top memory consumers: `ps aux --sort=-%mem | head -20`
   - Check for memory leaks or runaway processes
   - OOM (Out of Memory) events: `sudo journalctl -k | grep -i "out of memory"`

5. **Disk I/O analysis:**
   - Disk usage: `df -h`
   - Inode usage: `df -i`
   - I/O statistics: `iostat -x 1 5` (if sysstat installed)
   - Top I/O processes: `sudo iotop -b -n 1 | head -20` (if iotop installed)
   - Check for high disk wait: `top` and look at `wa` (wait) percentage
   - Disk health: `sudo smartctl -H /dev/sda` (for each drive)

6. **Process analysis:**
   - List all running processes: `ps aux`
   - Process tree: `pstree -p`
   - Zombie processes: `ps aux | grep Z`
   - Processes in D state (uninterruptible sleep): `ps aux | grep " D "`
   - Long-running processes: `ps -eo pid,user,start,time,cmd --sort=-time | head -20`

7. **Check for system resource contention:**
   - Context switches: `vmstat 1 5`
   - Interrupts: `cat /proc/interrupts`
   - Check if system is swapping heavily: `vmstat 1 5` (look at si/so columns)

8. **Network issues (can cause perceived slowness):**
   - Network connections: `ss -s`
   - Active connections: `netstat -tunap | wc -l` or `ss -tunap | wc -l`
   - DNS resolution test: `time nslookup google.com`
   - Check for network errors: `ip -s link`

9. **Graphics/Desktop environment (for GUI slowness):**
   - Check X server or Wayland compositor CPU usage
   - GPU usage (if nvidia): `nvidia-smi` or `watch -n 1 nvidia-smi`
   - For AMD: `radeontop` (if installed)
   - Check compositor settings (KDE Plasma on Wayland)
   - Desktop effects CPU usage

10. **Check system logs for errors:**
    - Recent errors: `sudo journalctl -p err -b`
    - Kernel messages: `dmesg | tail -50`
    - System log: `sudo journalctl -xe --no-pager | tail -100`
    - Look for specific issues:
      - Hardware errors
      - Driver issues
      - Service failures
      - Filesystem errors

11. **Check for background services/processes:**
    - List all services: `systemctl list-units --type=service --state=running`
    - Failed services: `systemctl --failed`
    - Check for update managers, indexing services (updatedb, baloo, tracker)
    - Snap services: `snap list` and check for snap updates
    - Flatpak: `flatpak list`

12. **Application-specific checks:**
    If slowness is application-specific:
    - Browser: check extensions, tabs, cache size
    - Database: check for long-running queries
    - IDE: check for indexing, plugins
    - Check application logs: `~/.local/share/applications/` or specific app log locations

13. **Historical data (if available):**
    - Check sar data: `sar -u` (if sysstat/sar configured)
    - Check historical logs: `sudo journalctl --since "1 day ago" -p err`

14. **Analyze and report findings:**
    Categorize issues found:
    - **CPU bottleneck**: High CPU usage, identify culprit processes
    - **Memory bottleneck**: High memory usage, swapping, suggest adding RAM or killing processes
    - **Disk I/O bottleneck**: High wait times, slow disk, suggest SSD upgrade or I/O optimization
    - **Thermal throttling**: High temperatures causing CPU slowdown
    - **Runaway processes**: Specific process consuming excessive resources
    - **Resource leaks**: Memory or handle leaks in specific applications
    - **Background tasks**: Indexing, updates, backups running
    - **Network issues**: DNS problems, slow network affecting system

15. **Provide recommendations:**
    Based on findings, suggest:
    - Kill or restart specific problematic processes
    - Disable unnecessary services
    - Adjust swappiness: `sudo sysctl vm.swappiness=10`
    - Clean up disk space if low
    - Update or reinstall problematic drivers
    - Install missing performance tools (sysstat, iotop, htop)
    - Schedule resource-intensive tasks for off-hours
    - Hardware upgrades (RAM, SSD) if appropriate
    - Investigate and fix application-specific issues
    - Check for and apply system updates
    - Reboot if system has been up for extended period with memory leaks

## Important notes:
- Install missing diagnostic tools if needed (sysstat, iotop, htop, lm-sensors)
- Use sudo for system-level diagnostics
- Be systematic - check CPU, memory, disk, and network in order
- Correlate findings with user's description of when slowness occurs
- Don't immediately kill processes - confirm with user first
- Consider both hardware and software causes
