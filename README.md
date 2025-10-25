# Claude Code Linux Desktop Slash Commands

[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-8A2BE2?logo=anthropic&logoColor=white)](https://claude.com/claude-code)
[![Linux](https://img.shields.io/badge/Linux-Desktop-FCC624?logo=linux&logoColor=black)](https://www.linux.org/)
[![Platform](https://img.shields.io/badge/Platform-Ubuntu%2025.04+-E95420?logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Claude Code Projects](https://img.shields.io/badge/Claude%20Code-Projects%20Index-8A2BE2?logo=anthropic&logoColor=white)](https://github.com/danielrosehill/Claude-Code-Repos-Index)
[![GitHub Index](https://img.shields.io/badge/GitHub-Master%20Index-181717?logo=github&logoColor=white)](https://github.com/danielrosehill/Github-Master-Index)

A comprehensive collection of slash commands for Claude Code CLI designed to streamline system administration, optimization, and configuration tasks on Linux desktop systems.

## Quick Start: Desktop SysAdmin Workspace

### Automated Workspace Setup

This repository includes a setup script that creates a dedicated Claude Code workspace for desktop system administration at `~/claude-spaces/desktop-sys-admin`.

**Run the setup script:**
```bash
bash ~/repos/github/Claude-Code-Linux-Desktop-Slash-Commands/setup-desktop-sysadmin-workspace.sh
```

**What the script does:**
1. Creates workspace directory structure at `~/claude-spaces/desktop-sys-admin`
2. Syncs all 93+ slash commands to `.claude/commands/` (organized by category)
3. Generates `CLAUDE.md` with workspace configuration and instructions
4. Gathers current system information (CPU, GPU, RAM, OS, network, dev tools) into `context/system-info.md`
5. Creates user-facing `README.md` documentation
6. Initializes a git repository for version control
7. Sets up `.gitignore` for temporary files

**Using the workspace:**
```bash
cd ~/claude-spaces/desktop-sys-admin
claude-code
```

Once in the workspace, Claude Code has full context about your system and access to all slash commands. Type `/` to see available commands organized by category.

**Updating the workspace:**

Re-run the setup script to sync the latest slash commands and refresh system information:
```bash
bash ~/repos/github/Claude-Code-Linux-Desktop-Slash-Commands/setup-desktop-sysadmin-workspace.sh
```

The script uses `rsync` to efficiently update only changed files while preserving the directory structure.

## Command Structure & Organization

### Two Directory Structures

This repository maintains slash commands in **two parallel structures**:

1. **`commands/`** - Organized by category in nested directories (primary source)
2. **`commands-flat/`** - Flattened structure with all commands in one directory

### Flattening Workflow

The `flatten-commands.sh` script converts the categorized structure into a flat structure for easy deployment to Claude Code workspaces.

**Run the flattening script:**
```bash
bash ~/repos/github/Claude-Code-Linux-Desktop-Slash-Commands/flatten-commands.sh
```

**What the script does:**
1. Clears the `commands-flat/` directory
2. Recursively finds all `.md` files in `commands/`
3. Flattens the directory structure by replacing `/` with `-` in filenames
4. Copies all commands to `commands-flat/`

**Example transformation:**
```
commands/system-health/system-upgrade.md → commands-flat/system-health-system-upgrade.md
commands/security/probe-vulnerabilities.md → commands-flat/security-probe-vulnerabilities.md
```

**When to use flattening:**
- Before copying commands to a Claude Code workspace
- When you need all commands in a single directory
- For easier deployment without preserving category structure

**Note:** The `setup-desktop-sysadmin-workspace.sh` script uses the categorized `commands/` structure (not the flattened version) to maintain organization in the workspace.

## Categories

### [AI/ML Setup](./ai-setup)
Local inference, GPU configuration, model management, speech-to-text setup

### [Backup](./backup)
Backup planning, target identification, backup strategies

### [Configuration](./configuration)
Git config, SSH keys, MCP servers, API keys, environment management

### [Debugging](./debugging)
System diagnostics, troubleshooting, crash analysis, performance debugging

### [Development Tools](./development-tools)
Docker setup, IDE suggestions, VS Code optimization

### [Filesystem Organization](./filesystem-organization)
File organization, folder consolidation, structure optimization

### [Hardware](./hardware)
Hardware profiling, GPU management, font management, wake device control

### [Installation](./installation)
CLI tool installation (gh, pipx, brew, rclone, AWS CLI, B2 CLI)

### [Management](./mgmt)
Repository management utilities

### [Media](./media)
Codec checking and recommendations

### [Miscellaneous](./misc)
General utilities and commands

### [Network](./network)
LAN scanning, connectivity diagnostics, network troubleshooting

### [Optimization](./optimisation)
System optimization and performance tuning

### [Package Management](./package-management)
Package cleanup, software evaluation, repository management

### [Program Management](./program-management)
Application management and organization

### [Python Environments](./python-environments)
pyenv, conda environments for data analysis, ROCm, LLM/STT fine-tuning

### [Repositories](./repositories)
Repository management and version control

### [Security](./security)
Vulnerability scanning, spyware detection, firewall analysis, security auditing

### [Storage](./storage)
Storage health monitoring, BTRFS/Snapper checks, RAID configuration, network mounts

### [System Health](./system-health)
Boot logs, slowdown diagnosis, health checkups, optimization

### [Utilities](./utilities)
Printer diagnostics, audio optimization, general system utilities

### [Virtualization](./virtualization)
Virtualization capabilities and configuration

## Related

[Claude Slash Commands](https://github.com/danielrosehill/Claude-Slash-Commands) - General collection of slash commands for Claude AI
