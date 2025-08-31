# Additions to be considered

This document outlines potential additions and improvements to the Unix-Like Audit Program.

## Security and Privilege Management

1. **Add the collection of `/etc/sudoers.d/` files** for individuals and groups privileges management.
2. **`/etc/security/limits.conf`** - System resource limits configuration

## Package Management and Logs

3. **Package management logs comparison**: `/var/log/dpkg.log` vs `/var/log/apt/history.log`?
4. **`eipp.log`** - Extended package information

## System Analysis

5. **`systemd-analyze`** - System boot performance analysis

## Audit System

6. **`auditctl -l`** - List current audit rules
7. **`ausearch`** - Search audit logs

## Authentication and Access Logs

8. **`/var/log/tallylog`** - Failed login attempts tracking

## System Status

9. **`/etc/status`** - System status information

---

## Additional Context

The following section contains reference information from a related Linux investigation system:

### System Information Collection Reference

Based on analysis of the `system_info.py` module from the Linux Investigation Triage Environment (LITE), the following categories are collected:

#### Core Collection Categories

**1. Operating System Information**
- OS release details from `/etc/os-release` (parsed into structured data)
- LSB release information via `lsb_release -a`
- Distribution-specific release files (Debian, RedHat, CentOS, Fedora, SuSE, Arch, Ubuntu)

**2. Kernel Information**
- Kernel version and details via `uname -a`
- Kernel boot parameters from `/proc/cmdline`
- Loaded kernel modules via `lsmod`

**3. Hardware Information**
- CPU details from `/proc/cpuinfo`
- Memory information from `/proc/meminfo`
- Disk/block device information via `lsblk`
- PCI devices via `lspci`

**4. Time and Timezone Information**
- Current system time via `date`
- Timezone configuration from `/etc/timezone`
- Time synchronization status via `timedatectl status`
- Hardware clock information via `hwclock --show`

**5. Environment Information**
- All environment variables via `env`
- Current shell information

**6. Performance Metrics**
- System load average from `/proc/loadavg`
- System uptime via `uptime`
- Disk usage statistics via `df -h`

**7. System Configuration**
- Running systemd services via `systemctl list-units --type=service`
- Network interface configuration via `ip addr show`

**8. Boot Information**
- Boot messages via `dmesg --time-format=iso`
- Boot time analysis via `systemd-analyze`

#### Collection Metadata
Each collection includes metadata with timestamp, extractor name ("SEA_System"), and version information. The module includes comprehensive error handling and logging for failed collection attempts.

This collector provides a thorough snapshot of the Linux system's current state, making it valuable for forensic analysis and system investigation purposes.