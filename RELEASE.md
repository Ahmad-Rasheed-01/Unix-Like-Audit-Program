# Unix-Like Audit Program v1.0.0

## Initial Release

We're excited to announce the first official release of the Unix-Like Audit Program, a comprehensive collection of system audit scripts designed to gather critical system information for security assessments, compliance audits, and system documentation across different Unix-like operating systems.

### What's Included

This release includes specialized audit scripts, each tailored for specific operating systems:

- **RedHat_v1.0.0.sh** - For RPM-based Linux systems (RHEL, CentOS, Fedora, etc.)
- **Oracle_v1.0.0.sh** - For Oracle Linux systems
- **SUSE_v1.0.0.sh** - For SUSE Linux Enterprise Server (SLES) and openSUSE systems
- **Debian-based_v1.0.0.sh** - For Debian-based Linux systems (Debian, Ubuntu, etc.)
- **AIX_v1.0.0.sh** - For IBM AIX Unix systems

### Key Features

#### Common Functionality
All scripts provide:

- **System Configuration Collection**: OS details, hostname, IP addresses, system files
- **User Management Analysis**: User accounts, groups, password policies, home directories
- **Security Settings Audit**: Sudoers configuration, audit rules, PAM settings
- **Network Configuration Inventory**: Network interfaces, open ports, routing information
- **Process Information Gathering**: Running processes and system services
- **Scheduled Tasks Documentation**: Cron jobs and scheduled tasks
- **System Logs Analysis**: Log file hierarchies and security logs
- **Time Synchronization Verification**: NTP/Chrony configuration and status
- **Package Management Inventory**: Installed packages and patches
- **Connectivity Testing**: Network connectivity verification

#### Script-Specific Features

- **RedHat_v1.0.0.sh**: RPM package management, SystemD service status, Chrony/NTP time synchronization
- **Oracle_v1.0.0.sh**: Oracle Linux specific configurations and package management
- **SUSE_v1.0.0.sh**: Zypper package management, SUSE-specific configuration files
- **Debian-based_v1.0.0.sh**: APT package management, SystemD service status, Debian/Ubuntu-specific configuration files
- **AIX_v1.0.0.sh**: AIX-specific system commands (lslpp, lsrc, lsgroup), AIX security configuration

### Output Format

Each script creates:
- A timestamped folder containing all collected information
- A compressed tar.gz archive of the folder

**Naming Convention:**
```
{hostname}[{ip_address}]{datetime}_{OS_TYPE}
{hostname}[{ip_address}]{datetime}_{OS_TYPE}.tar.gz
```

### Security and Performance

- **Read-Only Operation**: Scripts do not modify any system states or configurations
- **Timeout Protection**: Prevents hanging on large directory scans or file operations
- **Error Handling**: Gracefully handles missing commands and continues execution
- **Resource Efficiency**: Designed to minimize system impact during execution

### Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/Ahmad-Rasheed-01/Unix-Like-Audit-Program
   cd Unix-like-Audit-Program
   ```

2. Make the scripts executable:
   ```bash
   # Option 1: Make specific scripts executable
   chmod +x RedHat_v1.0.0.sh Oracle_v1.0.0.sh SUSE_v1.0.0.sh Debian-based_v1.0.0.sh AIX_v1.0.0.sh
   
   # Option 2: Make all shell scripts executable at once
   chmod +x *.sh
   ```

3. Execute the appropriate script for your system (requires root privileges):
   ```bash
   sudo ./RedHat_v1.0.0.sh       # For RedHat-based systems
   sudo ./Oracle_v1.0.0.sh       # For Oracle Linux systems
   sudo ./SUSE_v1.0.0.sh         # For SUSE Linux systems
   sudo ./Debian-based_v1.0.0.sh # For Debian-based systems
   sudo ./AIX_v1.0.0.sh          # For AIX systems
   ```

### Documentation

For detailed information on:
- Script functionality and collected information
- Security considerations and best practices
- Troubleshooting common issues
- Contributing guidelines

Please refer to the [README.md](README.md) file in the repository.

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Disclaimer:** These scripts collect system information for audit purposes. Users are responsible for ensuring appropriate authorization before execution and secure handling of collected data.