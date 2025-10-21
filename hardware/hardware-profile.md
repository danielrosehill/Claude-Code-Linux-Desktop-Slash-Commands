You are creating a comprehensive hardware profile of the system that is both AI-readable and human-readable.

## Your Task

Generate a detailed hardware summary by systematically profiling the following components:

### 1. CPU Profile
- **Model and specifications** using `lscpu`
- **Architecture details**: cores, threads, cache sizes
- **CPU frequency**: current, min, max
- **Virtualization support**: VT-x/AMD-V capabilities
- **CPU vulnerabilities**: Spectre, Meltdown, etc.
- **Performance governor** settings

### 2. Memory Profile
- **Total RAM** using `free -h` and `dmidecode -t memory`
- **Memory type and speed**: DDR3/DDR4/DDR5, frequency
- **Number of modules** and configuration (slots used/available)
- **Swap configuration**: size, type (partition/file)
- **Current usage** and available memory

### 3. Storage Profile
- **All storage devices** using `lsblk`, `fdisk -l`, and `smartctl`
- **Drive types**: NVMe, SSD, HDD, eMMC
- **Capacity and usage** for each device
- **Partition layout** and filesystem types
- **SMART health status** for drives that support it
- **Mount points** and usage percentages

### 4. Graphics Profile
- **GPU information** using `lspci | grep -i vga`, `lshw -C display`
- **GPU vendor and model**: NVIDIA, AMD, Intel
- **Driver information**: version and type (proprietary/open-source)
- **Display connections** and active monitors
- **VRAM** capacity (if available)
- **Vulkan/OpenGL support** using `vulkaninfo` and `glxinfo` if available

### 5. Network Profile
- **Network interfaces** using `ip addr` and `lshw -C network`
- **Interface types**: Ethernet, WiFi, virtual
- **MAC addresses** for physical interfaces
- **Link speeds** and duplex settings
- **Wireless capabilities**: protocols supported (802.11ac/ax, etc.)
- **Active connections** and IP configuration

### 6. System Board and Firmware
- **Motherboard details** using `dmidecode -t baseboard`
- **BIOS/UEFI information**: vendor, version, release date
- **System manufacturer and model**
- **Serial numbers** (if accessible and relevant)
- **Firmware capabilities**: UEFI features, secure boot status

### 7. Peripherals and Devices
- **USB devices** using `lsusb`
- **PCI devices** using `lspci`
- **Audio devices** using `aplay -l` and `lshw -C sound`
- **Input devices**: keyboards, mice, touchpads
- **Connected storage**: external drives, card readers

### 8. Thermal and Power
- **Temperature sensors** using `sensors` (if lm-sensors installed)
- **Fan speeds** and thermal zones
- **Battery information** (for laptops) using `upower -i /org/freedesktop/UPower/devices/battery_BAT0`
- **Power management** settings and capabilities

## Commands to Use

**System Overview:**
- `inxi -Fxz` - Comprehensive system information
- `hwinfo --short` - Hardware summary

**CPU:**
- `lscpu`
- `cat /proc/cpuinfo`
- `cpufreq-info` (if available)

**Memory:**
- `free -h`
- `sudo dmidecode -t memory`
- `cat /proc/meminfo`

**Storage:**
- `lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL`
- `sudo fdisk -l`
- `sudo smartctl -a /dev/sdX` (for each drive)
- `df -h`

**Graphics:**
- `lspci | grep -i vga`
- `sudo lshw -C display`
- `nvidia-smi` (for NVIDIA GPUs)
- `glxinfo | grep -i "opengl version"`

**Network:**
- `ip addr`
- `sudo lshw -C network`
- `iwconfig` (for wireless)
- `ethtool eth0` (for Ethernet)

**Motherboard/BIOS:**
- `sudo dmidecode -t baseboard`
- `sudo dmidecode -t bios`
- `sudo dmidecode -t system`

**Peripherals:**
- `lsusb -v`
- `lspci -v`
- `aplay -l`

**Thermal:**
- `sensors`
- `cat /sys/class/thermal/thermal_zone*/temp`

## Output Format

Create a structured report with the following sections:

### Executive Summary
- System type (desktop/laptop/server)
- Overall hardware generation/age
- Primary use case capabilities (gaming, development, general use)

### Detailed Hardware Profile

**CPU:**
- Model: [full CPU name]
- Cores/Threads: [physical cores]/[logical threads]
- Base/Max Frequency: [GHz]
- Cache: L1/L2/L3 sizes
- Features: [virtualization, security features]

**Memory:**
- Total: [GB] ([type] @ [speed])
- Configuration: [X modules in Y slots]
- Swap: [size] ([type])

**Storage:**
- Drive 1: [model] ([type]) - [capacity] - Health: [status]
- Drive 2: ...
- Total capacity: [TB]
- Partition layout: [summary]

**Graphics:**
- GPU: [model]
- Driver: [version and type]
- VRAM: [size]
- Displays: [count and configuration]

**Network:**
- Ethernet: [model] - [speed]
- WiFi: [model] - [protocols]
- Active connections: [summary]

**Motherboard:**
- Manufacturer: [brand]
- Model: [model number]
- BIOS: [version] ([date])

**Peripherals:**
- [List of notable USB/PCI devices]

**Thermal/Power:**
- Current temperatures: [CPU/GPU/etc.]
- Battery: [status if laptop]

### Hardware Capabilities Assessment

Rate and describe:
- **Performance tier**: Entry/Mid/High-end for [CPU/GPU/Storage/RAM]
- **Bottlenecks**: Identify any limiting components
- **Upgrade recommendations**: Suggest meaningful upgrades if applicable
- **Compatibility notes**: Linux driver status, known issues

### AI-Readable Summary (JSON)

Provide a structured JSON object:
```json
{
  "system_type": "desktop|laptop|server",
  "cpu": {
    "model": "",
    "cores": 0,
    "threads": 0,
    "base_ghz": 0.0,
    "max_ghz": 0.0
  },
  "memory": {
    "total_gb": 0,
    "type": "",
    "speed_mhz": 0
  },
  "storage": [
    {
      "device": "",
      "type": "nvme|ssd|hdd",
      "capacity_gb": 0,
      "health": "good|warning|critical"
    }
  ],
  "gpu": {
    "model": "",
    "vendor": "nvidia|amd|intel",
    "driver": "",
    "vram_gb": 0
  },
  "network": {
    "ethernet": {"present": true, "speed_mbps": 0},
    "wifi": {"present": true, "standard": ""}
  }
}
```

## Execution Guidelines

1. **Run commands systematically** in the order listed above
2. **Handle missing tools gracefully**: Note if `inxi`, `hwinfo`, `smartctl`, or `sensors` are not installed
3. **Use sudo appropriately**: Many hardware queries require root privileges
4. **Parse output carefully**: Extract relevant information, filter noise
5. **Cross-reference data**: Verify findings using multiple tools when possible
6. **Format for readability**: Use tables, bullet points, and clear hierarchies
7. **Include context**: Add brief explanations for technical specs
8. **Flag concerns**: Highlight any hardware issues, deprecated drivers, or thermal problems

## Important Notes

- Some commands may require installation of additional packages (`lm-sensors`, `smartmontools`, `pciutils`, etc.)
- SMART data requires drives that support it (most modern SSDs/HDDs)
- GPU information varies significantly by vendor
- Thermal data availability depends on sensor support
- Always respect privacy: avoid exposing serial numbers in shared contexts

Be thorough, accurate, and provide actionable insights about the hardware configuration.
