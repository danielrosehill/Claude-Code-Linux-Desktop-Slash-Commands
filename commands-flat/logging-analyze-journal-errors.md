# Analyze Journal Errors

You are helping the user parse systemd journal logs to identify recent errors and issues.

## Task

1. **Check recent errors from current boot:**
   ```bash
   # Errors from current boot
   journalctl -b -p err

   # Errors and warnings
   journalctl -b -p warning

   # Critical and alert level messages
   journalctl -b -p crit
   ```

2. **Show errors from specific time periods:**
   ```bash
   # Last hour
   journalctl --since "1 hour ago" -p err

   # Last 24 hours
   journalctl --since "24 hours ago" -p err

   # Specific date range
   journalctl --since "2025-10-25" --until "2025-10-26" -p err

   # Last 100 error entries
   journalctl -p err -n 100
   ```

3. **Group errors by service/unit:**
   ```bash
   # List units with failures
   systemctl --failed

   # Errors from specific service
   journalctl -u SERVICE_NAME -p err

   # Common problematic services
   journalctl -u NetworkManager -p err
   journalctl -u systemd-resolved -p err
   journalctl -u bluetooth -p err
   ```

4. **Analyze error frequency:**
   ```bash
   # Count errors by message
   journalctl -b -p err --no-pager | grep -oP '(?<=: ).*' | sort | uniq -c | sort -rn | head -20

   # Errors per unit
   journalctl -b -p err --no-pager | grep -oP '\w+\.service' | sort | uniq -c | sort -rn
   ```

5. **Check for kernel errors:**
   ```bash
   # Kernel errors
   journalctl -k -p err

   # Segfaults
   journalctl | grep -i "segfault"

   # OOM killer events
   journalctl | grep -i "killed process"
   ```

6. **Find patterns and recurring issues:**
   ```bash
   # I/O errors
   journalctl -b | grep -i "i/o error"

   # Disk errors
   journalctl -b | grep -i "ata.*error"

   # Network errors
   journalctl -b | grep -i "network.*error\|dhcp.*fail"

   # GPU/graphics errors
   journalctl -b | grep -i "amdgpu\|drm.*error"
   ```

7. **Export error summary:**
   ```bash
   # Save errors to file for analysis
   journalctl -b -p err --no-pager > /tmp/system-errors-$(date +%Y%m%d).log

   # Create error report
   cat > /tmp/error-report.txt << EOF
   System Error Report - $(date)
   ======================================

   Failed Services:
   $(systemctl --failed --no-pager)

   Recent Errors (last 24h):
   $(journalctl --since "24 hours ago" -p err --no-pager | tail -50)

   Error Summary by Service:
   $(journalctl -b -p err --no-pager | grep -oP '\w+\.service' | sort | uniq -c | sort -rn)
   EOF

   cat /tmp/error-report.txt
   ```

## Present Summary to User

Provide:
- Number of errors found in timeframe
- Most frequent error messages
- Services/units with errors
- Critical vs warning vs error breakdown
- Any patterns (disk, network, GPU issues)
- Recommended actions for common errors

## Common Error Patterns & Solutions

**NetworkManager errors:**
- DHCP timeout: Check network cable/WiFi
- DNS resolution: Check /etc/resolv.conf

**Bluetooth errors:**
- Adapter reset: `sudo systemctl restart bluetooth`
- Firmware missing: Check `dmesg | grep -i bluetooth`

**Disk errors:**
- I/O errors: Run SMART checks with `/check-disk-errors`
- Filesystem errors: May need `fsck`

**GPU errors:**
- AMDGPU: Check ROCm installation and kernel modules
- DRM errors: May indicate driver issues

**systemd-resolved errors:**
- DNSSEC validation failures: Common with some ISPs
- Fallback DNS: Configure in `/etc/systemd/resolved.conf`

## Additional Analysis

If requested:
- Compare error frequency over different boots: `journalctl --list-boots`
- Check correlation with specific events (updates, configuration changes)
- Identify error spikes: `journalctl -b -p err --output=short-monotonic`
- Export for external analysis: `journalctl -b -p err -o json`

## Notes

- Priority levels: 0=emerg, 1=alert, 2=crit, 3=err, 4=warning, 5=notice, 6=info, 7=debug
- Use `--no-pager` for scripting and piping
- Journal size can be checked with: `journalctl --disk-usage`
- Persistent journal: stored in `/var/log/journal/`
- Consider rotating old logs: `journalctl --vacuum-time=30d`
