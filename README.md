# Unix/Linux Audit Utility

A comprehensive collection of system audit scripts designed to gather critical system information for security assessments, compliance audits, and system documentation across different Unix-like operating systems.

**Note**: While the repository is named "Linux-Audit-Utility" for historical reasons, it actually supports both Linux and Unix systems, including IBM AIX.

## Overview

This repository contains three specialized audit scripts, each tailored for specific operating systems:

- **Oracle_Linux.sh** - For RPM-based Linux systems (Oracle Linux, RHEL, CentOS, etc.)
- **SUSE_Linux.sh** - For SUSE Linux Enterprise Server (SLES) and openSUSE systems
- **AIX.sh** - For IBM AIX Unix systems

## Features

### Common Functionality
All scripts collect the following system information:

- **System Configuration**: OS details, hostname, IP addresses, system files
- **User Management**: User accounts, groups, password policies, home directories
- **Security Settings**: Sudoers configuration, audit rules, PAM settings
- **Network Configuration**: Network interfaces, open ports, routing information
- **Process Information**: Running processes and system services
- **Scheduled Tasks**: Cron jobs and scheduled tasks
- **System Logs**: Log file hierarchies and security logs
- **Time Synchronization**: NTP/Chrony configuration and status
- **Package Management**: Installed packages and patches
- **Connectivity Tests**: Network connectivity verification

### Script-Specific Features

#### Oracle_Linux.sh
- RPM package management information
- SystemD service status
- Chrony/NTP time synchronization
- RedHat/Oracle-specific configuration files

#### SUSE_Linux.sh
- Zypper package management information
- SUSE-specific configuration files
- SystemD service management
- SUSE release information

#### AIX.sh
- AIX-specific system commands (lslpp, lsrc, lsgroup)
- AIX security configuration
- AIX firewall settings (ipfw)
- AIX-specific log locations

## Prerequisites

### System Requirements
- Root or sudo access is required
- Bash shell environment
- Standard Unix utilities (ls, cat, grep, etc.)

### Platform-Specific Requirements

#### Linux Systems (Oracle_Linux.sh, SUSE_Linux.sh)
- `timeout` command (for preventing hangs)
- `systemctl` (for service information)
- `netstat` or `ss` (for network information)

#### AIX Systems (AIX.sh)
- AIX-specific commands: `lslpp`, `lsrc`, `lsgroup`
- `ifconfig` (for network configuration)
- `ipfw` (for firewall information)

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd Linux-Audit-Utility
   ```

2. Make the scripts executable:
   ```bash
   chmod +x Oracle_Linux.sh
   chmod +x SUSE_Linux.sh
   chmod +x AIX.sh
   ```

## Usage

### Basic Execution

1. **For Oracle Linux/RHEL/CentOS systems:**
   ```bash
   sudo ./Oracle_Linux.sh
   ```

2. **For SUSE Linux systems:**
   ```bash
   sudo ./SUSE_Linux.sh
   ```

3. **For AIX systems:**
   ```bash
   sudo ./AIX.sh
   ```

### Output

Each script creates:
- A timestamped folder containing all collected information
- A compressed tar.gz archive of the folder

**Naming Convention:**
```
{hostname}[{ip_address}]{datetime}_{OS_TYPE}
{hostname}[{ip_address}]{datetime}_{OS_TYPE}.tar.gz
```

**Example outputs:**
- `server01[192.168.1.100]20240121_143022_RPM_Oracle_Linux.tar.gz`
- `suse-srv[10.0.0.50]20240121_143022_SUSE_Linux.tar.gz`
- `aix-host[172.16.1.10]20240121_143022_AIX.tar.gz`

## Collected Information

### Files Included in Output

| File Name | Description |
|-----------|-------------|
| `passwd`, `group`, `shadow` | User and group information |
| `sudoers`, `login.defs` | Security and login policies |
| `hosts`, `resolv.conf` | Network configuration |
| `os-release` | Operating system information |
| `auditd.conf`, `audit.rules` | Audit configuration |
| `password_change.txt` | Password change status for all users |
| `user_home_directories.txt` | Home directory information and statistics |
| `file_hierarchy.txt` | Log file directory structure |
| `logins.txt`, `who.txt` | Current login information |
| `ping_hostname.txt`, `ping_google.txt` | Network connectivity tests |
| `patches.txt` | Installed packages and patches |
| `network_ports.txt` | Open network ports |
| `services_status.txt` | System service status |
| `processes.txt` | Running processes |
| `ntp_sync_status.txt` | Time synchronization status |
| `cron_jobs.txt` | Scheduled tasks and cron jobs |

### Security Considerations

⚠️ **Important Security Notes:**

- Scripts collect sensitive system information including user accounts and configuration files
- Output files may contain sensitive data and should be handled securely
- Review script contents before execution in production environments
- Test scripts in non-production environments first
- Execute during off-peak hours to minimize system impact
- Ensure proper access controls on generated output files

For detailed security guidelines and vulnerability reporting, see our [Security Policy](SECURITY.md).

## Error Handling

### Timeout Protection
Linux scripts include timeout mechanisms to prevent hanging on:
- Large directory scans (`du -sh` with 30s timeout)
- File listing operations (`ls -la` with 15s timeout)
- Stat operations (`stat` with 10s timeout)

### Missing Commands
Scripts gracefully handle missing commands and will:
- Log missing files to `missing_files.txt`
- Provide alternative commands when available
- Continue execution despite individual command failures

## Troubleshooting

### Common Issues

1. **Permission Denied Errors**
   - Ensure script is run with root privileges
   - Check file permissions on system directories

2. **Script Hangs During Execution**
   - Large home directories may cause timeouts
   - Check system load and available resources

3. **Missing Output Files**
   - Verify sufficient disk space
   - Check write permissions in current directory

4. **Command Not Found Errors**
   - Some commands may not be available on all systems
   - Scripts will note missing commands in output

## Best Practices

1. **Pre-Execution Review**
   - Review script contents before execution
   - Understand what information will be collected
   - Ensure compliance with organizational policies

2. **Execution Environment**
   - Run during maintenance windows
   - Monitor system resources during execution
   - Ensure adequate disk space for output

3. **Output Management**
   - Secure storage of generated files
   - Regular cleanup of old audit files
   - Proper access controls and encryption

4. **Documentation**
   - Document when and why audits are performed
   - Maintain records of audit results
   - Track changes over time

## Contributing

Contributions are welcome! We encourage contributions for:
- Bug fixes and improvements
- Support for additional Unix/Linux distributions
- New data collection features
- Documentation enhancements
- Security improvements

Please see our [Contributing Guidelines](CONTRIBUTING.md) for detailed information on how to contribute.

Before contributing, please read our [Code of Conduct](CODE_OF_CONDUCT.md) to understand our community standards and guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Important:** While this software is open source, users are responsible for ensuring compliance with their organization's security policies and applicable regulations when using these audit scripts.

## Support

For issues, questions, or contributions, please use the repository's issue tracking system.

---

**Disclaimer:** These scripts collect system information for audit purposes. Users are responsible for ensuring appropriate authorization before execution and secure handling of collected data.