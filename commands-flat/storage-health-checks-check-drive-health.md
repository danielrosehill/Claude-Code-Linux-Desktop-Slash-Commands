# Hard Drive Health Check

You are helping the user run comprehensive health checks on all storage drives (SSD, HDD, NVMe, or mixed configurations).

## Your tasks:

1. **Identify all storage devices:**
   - List all block devices: `lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,MODEL,TRAN`
   - Get detailed disk information: `sudo lshw -class disk -short`
   - Identify device types (NVMe, SATA SSD, SATA HDD, etc.)

2. **Check SMART status for each device:**

   **For SATA/SAS drives (SSD and HDD):**
   - Check if smartmontools is installed: `which smartctl`
   - If not installed, ask user if they want to install it: `sudo apt install smartmontools`
   - For each drive, run:
     - `sudo smartctl -i /dev/sdX` (device info)
     - `sudo smartctl -H /dev/sdX` (health status)
     - `sudo smartctl -A /dev/sdX` (attributes)
     - `sudo smartctl -l error /dev/sdX` (error log)

   **For NVMe drives:**
   - Check NVMe tools: `which nvme`
   - For each NVMe drive, run:
     - `sudo nvme list`
     - `sudo nvme smart-log /dev/nvmeXn1`
     - `sudo smartctl -a /dev/nvmeXn1` (if smartctl supports NVMe)

3. **Analyze drive health indicators:**

   **For SSDs:**
   - Wear leveling count
   - Media wearout indicator
   - Available spare capacity
   - Percentage used
   - Total bytes written
   - Power-on hours
   - Reallocated sectors

   **For HDDs:**
   - Reallocated sector count
   - Current pending sectors
   - Offline uncorrectable sectors
   - Spin retry count
   - Power-on hours
   - Temperature
   - UDMA CRC errors

   **For NVMe:**
   - Critical warning
   - Temperature
   - Available spare
   - Percentage used
   - Data units read/written
   - Power cycles
   - Unsafe shutdowns

4. **Check filesystem health:**
   - Review dmesg for disk errors: `sudo dmesg | grep -i "error\|fail" | grep -i "sd\|nvme"`
   - Check system logs: `sudo journalctl -p err -g "sd\|nvme" --since "7 days ago"`

5. **Report findings:**
   - Summarize each drive's health status
   - Highlight any concerning indicators:
     - High reallocated sectors
     - High wear level on SSDs
     - Temperature issues
     - Errors in logs
     - Pending sectors
   - Calculate estimated remaining lifespan for SSDs based on wear indicators
   - Provide recommendations:
     - Drives that should be replaced soon
     - Drives that need monitoring
     - Whether to enable SMART monitoring if not active
     - Backup recommendations if drives show signs of failure

## Important notes:
- Use sudo for all SMART commands
- Be clear about the severity of any issues found
- Distinguish between informational metrics and critical warnings
- If smartmontools is not installed, offer to install it
- Some drives may not support all SMART features - this is normal
