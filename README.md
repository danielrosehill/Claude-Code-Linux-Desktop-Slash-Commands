# Claude Code Linux Desktop Slash Commands

A comprehensive collection of slash commands for Claude Code CLI designed to streamline system administration, optimization, and configuration tasks on Linux desktop systems (Ubuntu, Debian-based distributions).

## Overview

This repository provides over 75 ready-to-use slash commands that enable Claude Code to help with common Linux desktop administration tasks. Each slash command is a structured markdown file containing detailed instructions for Claude Code to execute specific system administration workflows.

## Features

### System Administration
- **Package Management**: Identify unused packages, evaluate installed software, manage third-party repositories, configure auto-updates
- **System Health**: Check boot logs, diagnose slowdowns and crashes, optimize boot speed, comprehensive health checkups
- **Security**: Security posture diagnostics, vulnerability scanning, spyware detection, firewall analysis, ClamAV installation
- **Hardware Profiling**: CPU, GPU, RAM, and motherboard profiling, hardware identity reporting, wake device management

### Storage & Filesystems
- **Health Monitoring**: BTRFS/Snapper health checks, drive health monitoring, RAID configuration checks
- **Network Mounts**: NFS and SMB mount setup and configuration
- **Backup**: Identify backup targets and suggest inclusion patterns
- **Filesystem Organization**: Organize loose files, consolidate folders, suggest optimal folder structures

### Development Environment
- **Python Environments**: Setup and manage pyenv, conda environments for data analysis, ROCm, LLM fine-tuning, and STT fine-tuning
- **Development Tools**: Docker setup, IDE suggestions, VS Code optimization
- **CLI Tools**: Install and configure gh CLI, pipx, brew, SDKman, yadm, rclone, AWS CLI, Backblaze B2 CLI

### AI/ML Setup
- **Local Inference**: Ollama setup and model suggestions, ComfyUI installation
- **GPU Configuration**: GPU-AI-ML assessment, GPU settings review, OS-GPU optimization checks
- **Speech-to-Text**: STT app setup including local Whisper
- **Audit Tools**: Evaluate local AI packages and suggest additions

### Configuration Management
- **Git**: Global gitignore setup, git config validation
- **SSH**: SSH key management, connection listing
- **MCP**: MCP server management
- **API Keys**: API key management and PATH configuration
- **Environment**: bashrc validation, PATH diagnostics, folder permission debugging

### Network & Media
- **Network Tools**: LAN scanning, connectivity diagnostics
- **Media**: Codec checking and recommendations
- **System Utilities**: Font management, Google Fonts installation, printer diagnostics
- **Audio**: PipeWire optimization

### Virtualization
- **Virtualization**: Check virtualization capabilities and configuration

## Technologies

- **Shell Scripting**: Bash commands and system utilities
- **Package Managers**: APT, Flatpak, Snap, pip, conda
- **System Tools**: systemd, journalctl, dpkg, SMART monitoring
- **AI/ML**: Ollama, ROCm, PyTorch, Whisper, ComfyUI
- **Version Control**: Git, GitHub CLI
- **Cloud Storage**: rclone, AWS CLI, Backblaze B2

## Structure

The repository is organized into logical categories using folders:

```
.
├── ai-setup/              # AI/ML setup and configuration
├── backup/                # Backup planning and tools
├── configuration/         # System and application configuration
├── debugging/             # System diagnostics and troubleshooting
├── development-tools/     # Developer environment setup
├── filesystem-organization/ # File and folder organization
├── hardware/              # Hardware profiling and management
├── installation/          # CLI tool installation scripts
├── media/                 # Media codec and playback
├── network/               # Network diagnostics and setup
├── package-management/    # Package installation and cleanup
├── python-environments/   # Python environment management
├── security/              # Security tools and auditing
├── storage/               # Storage and filesystem management
├── system-health/         # System health and optimization
├── utilities/             # General utilities
└── virtualization/        # Virtualization setup
```

## Usage

### Installing Slash Commands

1. Copy desired `.md` files to your Claude Code slash commands directory (typically `~/.claude/commands/` or `.claude/commands/` in your project)
2. Organize them using the folder structure to maintain the namespace
3. Invoke commands using the format: `/category:subcategory:command-name`

### Example Commands

```bash
# System health and diagnostics
/system-health:optimize-pipewire
/debugging:diagnose-slowdown
/debugging:check-boot-logs

# AI/ML setup
/ai-setup:setup-ollama
/ai-setup:suggest-ollama-models
/ai-setup:setup-comfyui

# Package management
/package-management:identify-unused-packages
/package-management:evaluate-installed-software
/package-management:check-third-party-repos

# Python environments
/python-environments:setup-conda-rocm
/python-environments:setup-conda-llm-finetune
/python-environments:manage-conda-environments

# Security
/security:probe-vulnerabilities
/security:detect-spyware
/security:firewall:analyze-firewall

# Hardware profiling
/hardware:hardware-profilers:hardware-profile
/hardware:hardware-profilers:by-component:profile-gpu
/hardware:check-gpu-os-optimization

# Configuration management
/configuration:check-git-config
/configuration:manage-ssh-keys
/configuration:manage-mcp-servers
```

### Command Format

Each slash command file follows a consistent structure:

```markdown
---
description: Brief description of the command
tags: [relevant, tags, for, categorization]
---

Detailed instructions for Claude Code to follow...

## Process
Step-by-step workflow

## Output
Expected results and reporting format
```

## Use Cases

### Daily System Maintenance
- Check system health and identify performance bottlenecks
- Review boot logs for errors
- Identify and remove unused packages
- Monitor storage health

### Development Setup
- Configure Python environments for specific workflows
- Install and configure development tools
- Set up Docker and containerization
- Manage git configuration

### AI/ML Workflows
- Set up local LLM inference with Ollama
- Configure ROCm for AMD GPU acceleration
- Prepare environments for model fine-tuning
- Install and configure ComfyUI for image generation

### Security Hardening
- Audit security posture
- Scan for vulnerabilities and spyware
- Configure firewall rules
- Manage SSH keys and access

### Troubleshooting
- Diagnose system slowdowns
- Analyze crash reports
- Check hardware health
- Debug network connectivity issues

## Target Environment

Designed for:
- **OS**: Ubuntu 25.04+ (adaptable to other Debian-based distributions)
- **Desktop Environment**: KDE Plasma, GNOME, or other Linux DEs
- **Display Server**: Wayland or X11
- **Hardware**: AMD/Intel CPUs, AMD/NVIDIA GPUs
- **Use Case**: Developer workstations, power user desktops, AI/ML systems

## Contributing Workflow

This repository follows a structured workflow for developing new slash commands:

1. User provides direction on desired slash commands
2. Collaborative ideation to define command scope and functionality
3. Creation of markdown files with clear, actionable instructions
4. Organization into appropriate category folders
5. Testing and refinement based on real-world usage
