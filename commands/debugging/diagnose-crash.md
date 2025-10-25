# Diagnose Program Crash

You are helping the user diagnose a recent program crash. Ask for additional context from the user, but start by checking obvious places in the logs.

## Your tasks:

1. **Gather information from the user:**
   Ask the user:
   - What program crashed?
   - When did it crash (approximate time)?
   - What were they doing when it crashed?
   - Does it crash consistently or intermittently?
   - Any error messages displayed?

2. **Check system journal for crash information:**
   - Recent errors: `sudo journalctl -p err -b`
   - Last 100 log entries: `sudo journalctl -n 100 --no-pager`
   - If user knows approximate time:
     ```bash
     sudo journalctl --since "10 minutes ago" -p warning
     sudo journalctl --since "YYYY-MM-DD HH:MM:SS"
     ```
   - Search for specific program name:
     ```bash
     sudo journalctl -b | grep -i "<program-name>"
     ```

3. **Check kernel logs (dmesg):**
   - Recent kernel messages: `dmesg | tail -100`
   - Look for segmentation faults, OOM kills, kernel panics
   - Search for program name: `dmesg | grep -i "<program-name>"`
   - Check for OOM (Out of Memory) kills:
     ```bash
     dmesg | grep -i "killed process"
     sudo journalctl -k | grep -i "out of memory"
     ```

4. **Check for core dumps:**
   - Check if core dumps are enabled: `ulimit -c`
   - System core dump pattern: `cat /proc/sys/kernel/core_pattern`
   - Look for core dumps:
     ```bash
     find /var/lib/systemd/coredump -name "*<program-name>*" -mtime -1
     find . -name "core*" -mtime -1
     ```
   - If systemd-coredump is used:
     ```bash
     coredumpctl list
     coredumpctl info <pid>
     coredumpctl dump <pid> -o /tmp/core.dump
     ```

5. **Check application-specific logs:**
   - User logs: `~/.local/share/applications/`
   - Xsession errors: `cat ~/.xsession-errors`
   - Application cache: `~/.cache/<program-name>/`
   - Application config: `~/.config/<program-name>/`
   - System logs: `/var/log/`
   - Application-specific locations:
     - Web browsers: `~/.mozilla/`, `~/.config/google-chrome/`
     - Snaps: `snap logs <snap-name>`
     - Flatpaks: `flatpak logs`

6. **Check crash reporter systems:**
   - Ubuntu Apport crashes:
     ```bash
     ls -lt /var/crash/
     ubuntu-bug <program-name>  # to file bug report
     ```
   - GNOME crash reports (if applicable): `~/.local/share/gnome-shell/`
   - KDE crash reports: `~/.local/share/drkonqi/`

7. **Check resource issues at crash time:**
   - Memory usage: `free -h`
   - Disk space: `df -h`
   - Check if system was swapping heavily before crash
   - Recent high memory usage: `sudo journalctl | grep -i "out of memory"`

8. **Check for dependency issues:**
   - Missing libraries:
     ```bash
     ldd $(which <program-name>)
     ```
   - Check if program still exists and is executable:
     ```bash
     which <program-name>
     ls -la $(which <program-name>)
     ```
   - Version information: `<program-name> --version`

9. **Check for recent system changes:**
   - Recent package updates: `grep " install \| upgrade " /var/log/dpkg.log | tail -50`
   - Recent system updates: `grep "upgrade" /var/log/apt/history.log | tail -20`
   - Kernel changes: `ls -lt /boot/vmlinuz-*`

10. **Graphics/display-related crashes:**
    If GUI application:
    - X server errors: `grep -i "error\|segfault" /var/log/Xorg.0.log`
    - Wayland compositor logs: `journalctl -b | grep -i "kwin\|wayland"`
    - GPU issues:
      ```bash
      nvidia-smi  # for NVIDIA
      dmesg | grep -i "gpu\|nvidia\|amdgpu\|radeon"
      ```

11. **Check for known issues:**
    - Search package bug tracker: `ubuntu-bug --package <package-name>`
    - Check if issue is reproducible
    - Check program's GitHub issues (if applicable)

12. **Analyze crash signatures:**
    Look for common crash indicators:
    - **Segmentation fault (SIGSEGV)**: Memory access violation
    - **SIGABRT**: Program called abort()
    - **SIGILL**: Illegal instruction
    - **SIGBUS**: Bus error
    - **SIGFPE**: Floating point exception
    - **OOM Killer**: Process killed due to out of memory
    - **Stack trace**: If available in logs

13. **Try to reproduce the crash:**
    If possible, guide user to:
    - Run program from terminal to see error output:
      ```bash
      <program-name> 2>&1 | tee /tmp/program-output.log
      ```
    - Run with debug logging (if supported):
      ```bash
      <program-name> --debug
      <program-name> --verbose
      ```
    - Check environment variables that might affect behavior

14. **Report findings:**
    Summarize:
    - Probable cause of crash (if identified)
    - Relevant log entries
    - Any error messages or stack traces found
    - Resource issues if any
    - Recent system changes that might be related

15. **Provide recommendations:**
    Based on findings, suggest:
    - **If OOM kill**: Reduce memory usage, close other programs, add more RAM/swap
    - **If segfault**: Check for updates, try reinstalling program, report bug
    - **If dependency issue**: Reinstall program and dependencies
    - **If config issue**: Reset configuration, move config to backup
    - **If disk full**: Free up disk space
    - **If recent update**: Consider downgrading or wait for fix
    - **If reproducible**: Enable debug mode, create bug report with steps
    - **If GPU-related**: Update drivers, check GPU health
    - How to enable better crash reporting (core dumps, apport)
    - Consider running program under debugger (gdb) if user is technical

## Important notes:
- Use sudo for system logs and journal access
- Times in logs are usually in UTC - account for timezone
- Be sensitive that crashes can be frustrating for users
- Some log files can be very large - use grep and tail to filter
- Core dumps can be very large - ask before extracting
- Privacy: don't ask to see sensitive information from logs
- If no obvious cause is found, explain what additional info would help
