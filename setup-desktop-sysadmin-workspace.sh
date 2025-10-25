#!/bin/bash

# Desktop System Administration Claude Workspace Setup Script
# Creates and configures ~/claude-spaces/desktop-sys-admin with slash commands and context

set -e  # Exit on error

# Color output for better visibility
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_DIR="$(dirname "$(readlink -f "$0")")"
WORKSPACE_DIR="$HOME/claude-spaces/desktop-sys-admin"
COMMANDS_SOURCE_DIR="$REPO_DIR/commands-flat"
COMMANDS_TARGET_DIR="$WORKSPACE_DIR/.claude/commands"
CLAUDE_MD="$WORKSPACE_DIR/CLAUDE.md"
CONTEXT_DIR="$WORKSPACE_DIR/context"
SYSTEM_INFO_FILE="$CONTEXT_DIR/system-info.md"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Desktop SysAdmin Claude Workspace Setup${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Create workspace directory if it doesn't exist
if [ ! -d "$WORKSPACE_DIR" ]; then
    echo -e "${YELLOW}Creating workspace directory: $WORKSPACE_DIR${NC}"
    mkdir -p "$WORKSPACE_DIR"
    echo -e "${GREEN}✓ Workspace directory created${NC}\n"
else
    echo -e "${GREEN}✓ Workspace directory already exists${NC}\n"
fi

# Flatten commands first if needed
if [ ! -d "$COMMANDS_SOURCE_DIR" ] || [ "$REPO_DIR/commands" -nt "$COMMANDS_SOURCE_DIR" ]; then
    echo -e "${YELLOW}Flattening command structure...${NC}"
    if [ -f "$REPO_DIR/flatten-commands.sh" ]; then
        cd "$REPO_DIR"
        bash "$REPO_DIR/flatten-commands.sh" > /dev/null 2>&1
        echo -e "${GREEN}✓ Commands flattened${NC}\n"
    else
        echo -e "${RED}✗ flatten-commands.sh not found${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ Flattened commands are up to date${NC}\n"
fi

# Create .claude/commands directory structure
echo -e "${YELLOW}Setting up .claude/commands directory...${NC}"
mkdir -p "$COMMANDS_TARGET_DIR"
echo -e "${GREEN}✓ Commands directory ready${NC}\n"

# Sync slash commands from source to workspace
echo -e "${YELLOW}Syncing slash commands...${NC}"
if [ -d "$COMMANDS_SOURCE_DIR" ]; then
    # Use rsync to sync commands, preserving structure and only updating changed files
    # NOTE: Does NOT use --delete flag to preserve custom/user-added commands
    rsync -av "$COMMANDS_SOURCE_DIR/" "$COMMANDS_TARGET_DIR/"

    # Count total commands (including custom ones)
    COMMAND_COUNT=$(find "$COMMANDS_TARGET_DIR" -type f -name "*.md" ! -name "README.md" | wc -l)
    REPO_COMMAND_COUNT=$(find "$COMMANDS_SOURCE_DIR" -type f -name "*.md" ! -name "README.md" | wc -l)

    echo -e "${GREEN}✓ Synced commands from repository${NC}"
    echo -e "${BLUE}  Repository commands: $REPO_COMMAND_COUNT${NC}"
    echo -e "${BLUE}  Total commands in workspace: $COMMAND_COUNT${NC}"

    if [ $COMMAND_COUNT -gt $REPO_COMMAND_COUNT ]; then
        CUSTOM_COUNT=$((COMMAND_COUNT - REPO_COMMAND_COUNT))
        echo -e "${YELLOW}  Custom commands preserved: $CUSTOM_COUNT${NC}"
    fi
    echo ""
else
    echo -e "${RED}✗ Source commands directory not found: $COMMANDS_SOURCE_DIR${NC}"
    exit 1
fi

# Create CLAUDE.md file
echo -e "${YELLOW}Creating CLAUDE.md configuration...${NC}"
cat > "$CLAUDE_MD" << 'EOF'
# Desktop System Administration Claude Workspace

## Purpose

This workspace serves as the central point for Claude Code to administer this Linux desktop system. It provides a comprehensive set of slash commands for common system administration tasks, diagnostics, and configuration management.

## What This Workspace Provides

### Comprehensive Slash Commands

This workspace includes a wide range of slash commands organized by category:

- **AI Tools**: Setup and management of local AI infrastructure (Ollama, ComfyUI, speech-to-text, GPU assessment)
- **Backup**: Backup strategy and target identification
- **Cloud**: Cloud CLI setup (AWS, Backblaze B2, rclone)
- **Configuration**: System configuration management (git, SSH, API keys, bash aliases, MCP servers)
- **Debugging**: System diagnostics (crashes, slowdowns, memory leaks, disk usage)
- **Development**: Development environment setup (conda, pyenv, IDEs)
- **Hardware**: Hardware diagnostics and optimization (GPU, printers, codecs, wake devices)
- **Maintenance**: System maintenance (updates, health checks, startup services, package management)
- **Network**: Network diagnostics and management (LAN scanning, connectivity, router access)
- **Security**: Security auditing (vulnerabilities, spyware detection)
- **Software**: Software evaluation and management
- **Text Processing**: Text conversion utilities (casual-to-business, business-to-casual)
- **UI/UX**: Font management and installation

### How to Use This Workspace

1. **Launch Claude Code** in this workspace directory:
   ```bash
   cd ~/claude-spaces/desktop-sys-admin
   claude-code
   ```

2. **Browse available commands**: All slash commands are located in `.claude/commands/` organized by category

3. **Execute commands**: Type `/` followed by the command name, e.g., `/system-health-checkup`

4. **System Context**: Claude has access to comprehensive system information in the `context/` directory

### Workspace Structure

```
~/claude-spaces/desktop-sys-admin/
├── .claude/
│   └── commands/          # All slash commands organized by category
├── context/               # System context and information
│   └── system-info.md    # Current system specifications
├── CLAUDE.md             # This file
└── README.md             # User-facing documentation
```

## System Context

Claude has been provided with detailed system information including:
- Hardware specifications (CPU, GPU, RAM, storage)
- Software environment (OS, kernel, desktop environment)
- Development tools and languages available
- Network configuration
- Installed services and tools

This context is automatically updated when you run the setup script.

## Updating Commands

To sync the latest slash commands from the repository:

```bash
bash ~/repos/github/Claude-Code-Linux-Desktop-Slash-Commands/setup-desktop-sysadmin-workspace.sh
```

This will update all commands and refresh system context information.

## Philosophy

This workspace enables Claude Code to:
- Perform system administration tasks with full context
- Execute diagnostics and troubleshooting
- Configure and optimize system components
- Manage development environments
- Maintain system health and security

All operations are performed with awareness of your specific system configuration and preferences.
EOF

echo -e "${GREEN}✓ CLAUDE.md created${NC}\n"

# Create context directory
echo -e "${YELLOW}Setting up context directory...${NC}"
mkdir -p "$CONTEXT_DIR"

# Generate system information file
echo -e "${YELLOW}Gathering system information...${NC}"
cat > "$SYSTEM_INFO_FILE" << 'EOF'
# System Information

This file contains current system specifications and configuration for context-aware system administration.

## Hardware Specifications

EOF

# Add CPU information
echo "### CPU" >> "$SYSTEM_INFO_FILE"
echo '```' >> "$SYSTEM_INFO_FILE"
lscpu | grep -E "Model name|Architecture|CPU\(s\)|Thread|Core" >> "$SYSTEM_INFO_FILE" 2>/dev/null || echo "CPU info not available"
echo '```' >> "$SYSTEM_INFO_FILE"
echo "" >> "$SYSTEM_INFO_FILE"

# Add GPU information
echo "### GPU" >> "$SYSTEM_INFO_FILE"
echo '```' >> "$SYSTEM_INFO_FILE"
if command -v lspci &> /dev/null; then
    lspci | grep -i "vga\|3d\|display" >> "$SYSTEM_INFO_FILE" 2>/dev/null || echo "GPU info not available"
fi
echo '```' >> "$SYSTEM_INFO_FILE"
echo "" >> "$SYSTEM_INFO_FILE"

# Add memory information
echo "### Memory" >> "$SYSTEM_INFO_FILE"
echo '```' >> "$SYSTEM_INFO_FILE"
free -h >> "$SYSTEM_INFO_FILE" 2>/dev/null || echo "Memory info not available"
echo '```' >> "$SYSTEM_INFO_FILE"
echo "" >> "$SYSTEM_INFO_FILE"

# Add storage information
echo "### Storage" >> "$SYSTEM_INFO_FILE"
echo '```' >> "$SYSTEM_INFO_FILE"
df -h / >> "$SYSTEM_INFO_FILE" 2>/dev/null || echo "Storage info not available"
echo '```' >> "$SYSTEM_INFO_FILE"
echo "" >> "$SYSTEM_INFO_FILE"

# Add OS information
cat >> "$SYSTEM_INFO_FILE" << 'EOF'
## Operating System

EOF

echo '```' >> "$SYSTEM_INFO_FILE"
if [ -f /etc/os-release ]; then
    cat /etc/os-release >> "$SYSTEM_INFO_FILE"
else
    echo "OS release info not available" >> "$SYSTEM_INFO_FILE"
fi
echo '```' >> "$SYSTEM_INFO_FILE"
echo "" >> "$SYSTEM_INFO_FILE"

# Add kernel information
echo "### Kernel" >> "$SYSTEM_INFO_FILE"
echo '```' >> "$SYSTEM_INFO_FILE"
uname -a >> "$SYSTEM_INFO_FILE" 2>/dev/null || echo "Kernel info not available"
echo '```' >> "$SYSTEM_INFO_FILE"
echo "" >> "$SYSTEM_INFO_FILE"

# Add desktop environment
cat >> "$SYSTEM_INFO_FILE" << 'EOF'
## Desktop Environment

EOF

echo '```' >> "$SYSTEM_INFO_FILE"
echo "Desktop: ${XDG_CURRENT_DESKTOP:-Not detected}" >> "$SYSTEM_INFO_FILE"
echo "Session: ${XDG_SESSION_TYPE:-Not detected}" >> "$SYSTEM_INFO_FILE"
echo '```' >> "$SYSTEM_INFO_FILE"
echo "" >> "$SYSTEM_INFO_FILE"

# Add network configuration
cat >> "$SYSTEM_INFO_FILE" << 'EOF'
## Network Configuration

### Network Interfaces
```
EOF

ip -br addr >> "$SYSTEM_INFO_FILE" 2>/dev/null || echo "Network info not available" >> "$SYSTEM_INFO_FILE"
echo '```' >> "$SYSTEM_INFO_FILE"
echo "" >> "$SYSTEM_INFO_FILE"

# Add installed development tools
cat >> "$SYSTEM_INFO_FILE" << 'EOF'
## Development Environment

### Programming Languages & Runtimes
```
EOF

# Check for various tools
for tool in python3 node java go rust gcc make docker podman conda; do
    if command -v $tool &> /dev/null; then
        case $tool in
            python3)
                echo "Python: $(python3 --version 2>&1)" >> "$SYSTEM_INFO_FILE"
                ;;
            node)
                echo "Node.js: $(node --version 2>&1)" >> "$SYSTEM_INFO_FILE"
                ;;
            java)
                echo "Java: $(java -version 2>&1 | head -1)" >> "$SYSTEM_INFO_FILE"
                ;;
            go)
                echo "Go: $(go version 2>&1)" >> "$SYSTEM_INFO_FILE"
                ;;
            rust)
                echo "Rust: $(rustc --version 2>&1)" >> "$SYSTEM_INFO_FILE"
                ;;
            gcc)
                echo "GCC: $(gcc --version 2>&1 | head -1)" >> "$SYSTEM_INFO_FILE"
                ;;
            make)
                echo "Make: $(make --version 2>&1 | head -1)" >> "$SYSTEM_INFO_FILE"
                ;;
            docker)
                echo "Docker: $(docker --version 2>&1)" >> "$SYSTEM_INFO_FILE"
                ;;
            podman)
                echo "Podman: $(podman --version 2>&1)" >> "$SYSTEM_INFO_FILE"
                ;;
            conda)
                echo "Conda: $(conda --version 2>&1)" >> "$SYSTEM_INFO_FILE"
                ;;
        esac
    fi
done

echo '```' >> "$SYSTEM_INFO_FILE"
echo "" >> "$SYSTEM_INFO_FILE"

# Add timestamp
cat >> "$SYSTEM_INFO_FILE" << EOF

---
*Last updated: $(date)*
EOF

echo -e "${GREEN}✓ System information gathered${NC}\n"

# Create README.md
echo -e "${YELLOW}Creating README.md...${NC}"
cat > "$WORKSPACE_DIR/README.md" << 'EOF'
# Desktop System Administration Workspace

This is a specialized Claude Code workspace for administering this Linux desktop system.

## Quick Start

1. Navigate to this workspace:
   ```bash
   cd ~/claude-spaces/desktop-sys-admin
   ```

2. Launch Claude Code:
   ```bash
   claude-code
   ```

3. Use slash commands for system administration tasks. Type `/` to see available commands.

## Available Command Categories

- **AI Tools** - Setup and manage local AI infrastructure
- **Backup** - Backup planning and management
- **Cloud** - Cloud service CLI setup
- **Configuration** - System configuration management
- **Debugging** - System diagnostics and troubleshooting
- **Development** - Development environment setup
- **Hardware** - Hardware diagnostics and optimization
- **Maintenance** - System updates and health checks
- **Network** - Network diagnostics and management
- **Security** - Security auditing and scanning
- **Software** - Software evaluation and management
- **Text Processing** - Text conversion utilities
- **UI/UX** - Font and interface management

## Updating This Workspace

To sync the latest commands and refresh system information:

```bash
bash ~/repos/github/Claude-Code-Linux-Desktop-Slash-Commands/setup-desktop-sysadmin-workspace.sh
```

## Documentation

- `CLAUDE.md` - Configuration and context for Claude Code
- `context/system-info.md` - Current system specifications
- `.claude/commands/` - All available slash commands

## Philosophy

This workspace provides Claude Code with comprehensive system context and specialized commands to effectively administer your Linux desktop.
EOF

echo -e "${GREEN}✓ README.md created${NC}\n"

# Initialize git repository if not already initialized
if [ ! -d "$WORKSPACE_DIR/.git" ]; then
    echo -e "${YELLOW}Initializing git repository...${NC}"
    cd "$WORKSPACE_DIR"
    git init

    # Create .gitignore
    cat > .gitignore << 'EOF'
# Temporary files
*.tmp
*.log
.DS_Store

# IDE
.vscode/
.idea/

# Local overrides
local/
EOF

    echo -e "${GREEN}✓ Git repository initialized${NC}\n"
fi

# Summary
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "Workspace location: ${YELLOW}$WORKSPACE_DIR${NC}"
echo -e "Slash commands synced: ${YELLOW}$COMMAND_COUNT${NC}"
echo -e "\nTo use this workspace:"
echo -e "  ${BLUE}cd $WORKSPACE_DIR${NC}"
echo -e "  ${BLUE}claude-code${NC}"
echo -e "\nTo update commands and system info:"
echo -e "  ${BLUE}bash $(readlink -f "$0")${NC}\n"
