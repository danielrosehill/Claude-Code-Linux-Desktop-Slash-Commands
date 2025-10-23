Review system boot process and identify issues.

Your task:
1. Scan boot messages and journal logs:
   ```bash
   journalctl -b  # Current boot
   journalctl -b -1  # Previous boot
   ```

2. Identify issues:
   - Failed services
   - Error messages
   - Warnings
   - Slow-starting services
   - Dependency problems

3. Analyze boot performance:
   ```bash
   systemd-analyze  # Overall boot time
   systemd-analyze blame  # Time per service
   systemd-analyze critical-chain  # Critical path
   ```

4. Suggest remediation:
   - Fix failed services
   - Disable unnecessary services
   - Resolve dependency issues
   - Optimize slow services

5. Provide actionable recommendations:
   - Commands to investigate specific issues
   - Configuration changes needed
   - Services to disable or reconfigure
   - Further diagnostic steps

Proactively identify and suggest fixes for boot-time issues.
