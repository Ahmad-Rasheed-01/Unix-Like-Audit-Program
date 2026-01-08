#!/bin/bash

# Set PATH to include standard Solaris directories
export PATH=/usr/xpg4/bin:/usr/bin:/usr/sbin:/sbin:$PATH


#########################################################################################
#                             USER GUIDE                                                #
#---------------------------------------------------------------------------------------#
# Version: 1.0.0                                                                        #
# Author: Ahmad Rasheed                                                                 #
# This script collects system information and compresses it to a timestamped            #
# tar.gz file.                                                                          #
#                                                                                       #
# Prerequisites:                                                                        #
# a) The script must be run as root (sudo).                                             #
# b) Make the script executable by running:                                             #
#      chmod +x Solaris.sh                                                              #
# c) Execute the script using:                                                          #
#      sudo ./Solaris.sh                                                                #
# d) The script automatically creates a tar.gz file in the current directory.           #
# e) Share the generated tar.gz file as needed.                                         #
#                                                                                       # 
#                                                                                       #
#---------------------------------------------------------------------------------------#
#                       Operational Instructions                                        #
#---------------------------------------------------------------------------------------#
# a) Scrutinize the contents of the script to ensure that it does not contain           #
#    any statements, commands or any other code that might negatively influence         #
#    the environment(s) in either a security or operational way.                        #
# b) Test the script on the test environment to ensure that it does not contain         #
#    any statements, commands or any other code that might negatively influence         #
#    the environment(s) in either a security or operational way.                        #
# c) The final responsibility for executing this script lies with the executor.         #
# d) It is advised to execute the script during off-peak hours.                         #
#                                                                                       #
# Notes:                                                                                #
# - This script is designed for Oracle Solaris systems.                                 #
# - Ensure you have sufficient permissions to read system files.                        #
# - Some commands/files may not be available depending on the OS version.               #
# - This script is READ-ONLY and does not modify any system states or configurations.   #
# - For updates, visit: https://github.com/Ahmad-Rasheed-01/Unix-like-Audit-Program     #
#                                                                                       #
#########################################################################################

#########################################################################################
#                                   CHANGE LOG                                          #
#---------------------------------------------------------------------------------------#
#  Date      | Version | Author        | Description                                    #
#---------------------------------------------------------------------------------------#
# 2026-01-06 | 1.0.0   | Ahmad Rasheed | - Initial Release                              #
#---------------------------------------------------------------------------------------#
#                                                                                       #
#########################################################################################

# color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[1;34m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# Display banner
echo -e "${YELLOW}"
echo -e "══════════════════════════════════════════════════════════════════════════════════════════════════════════════"
echo -e "                                                                                                            "
echo -e "    ${WHITE} ███████╗ ██████╗ ██╗      █████╗ ██████╗ ██╗███████╗${YELLOW}                                          "
echo -e "    ${WHITE} ██╔════╝██╔═══██╗██║     ██╔══██╗██╔══██╗██║██╔════╝${YELLOW}                                          "
echo -e "    ${WHITE} ███████╗██║   ██║██║     ███████║██████╔╝██║███████╗${YELLOW}                                          "
echo -e "    ${WHITE} ╚════██║██║   ██║██║     ██╔══██║██╔══██╗██║╚════██║${YELLOW}                                          "
echo -e "    ${WHITE} ███████║╚██████╔╝███████╗██║  ██║██║  ██║██║███████║${YELLOW}                                          "
echo -e "    ${WHITE} ╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝${YELLOW}                                          "
echo -e "                                                                                                            "
echo -e "                                 ${CYAN}🔒 A Security Audit Utility 🔒${YELLOW}                                   "
echo -e "                                ${GREEN}Developed under Unix-Like Audit Program${YELLOW}                             "
echo -e "                                                                                                            "
echo -e "                                                                                                            "
echo -e "    ${WHITE}Platform: Oracle Solaris${YELLOW}                                                                       "
echo -e "    ${WHITE}Version: 1.0.0${YELLOW}                                                                                 "
echo -e "    ${WHITE}For Updates Please Visit: https://github.com/Ahmad-Rasheed-01/Unix-Like-Audit-Program${YELLOW}          "
echo -e "                                                                                                            "
echo -e "══════════════════════════════════════════════════════════════════════════════════════════════════════════════"
echo -e "${NC}"
echo

# Logging functions
LOG_FILE=""

log_to_file() {
    if [ -n "$LOG_FILE" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
    fi
}

log_info() {
    echo -e "${GREEN}[INFO] $1${NC}"
    log_to_file "[INFO] $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN] $1${NC}"
    log_to_file "[WARN] $1"
}

log_error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
    log_to_file "[ERROR] $1"
}

log_file_operation() {
    local operation="$1"
    local file="$2"
    local status="$3"
    
    if [ "$status" = "success" ]; then
        echo -e "${GREEN}✓ $operation: $file${NC}"
        log_to_file "[SUCCESS] $operation: $file"
    else
        echo -e "${RED}✗ $operation: $file${NC}"
        log_to_file "[FAILURE] $operation: $file"
    fi
}

# Function to detect OS and validate script compatibility
check_os_compatibility() {
    local detected_os="Unknown"
    local script_type="Oracle Solaris"
    local repo_url="https://github.com/Ahmad-Rasheed-01/Unix-Like-Audit-Program"
    
    # Detect operating system
    if [ "$(uname -s)" = "SunOS" ]; then
        detected_os="Oracle Solaris"
        echo -e "${GREEN}✓ OS Detection: $detected_os detected${NC}"
        echo -e "${GREEN}✓ Script Compatibility: This script is compatible with your system${NC}"
        echo
        read -p "Do you want to continue with the collection? (Y/n): " REPLY
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            echo -e "${RED}Collection cancelled by user.${NC}"
            exit 0
        fi
        echo -e "${CYAN}Continuing with $script_type collection...${NC}"
        echo
        return 0
    else
        detected_os="$(uname -s)"
    fi
    
    # If we reach here, the OS is not compatible
    echo -e "${RED}✗ OS Detection: $detected_os detected${NC}"
    echo -e "${RED}✗ Script Compatibility: This script is designed for $script_type systems${NC}"
    echo -e "${YELLOW}Please use the appropriate script for your operating system:${NC}"
    echo -e "${WHITE}  • For RedHat/RHEL: RedHat.sh${NC}"
    echo -e "${WHITE}  • For Oracle Linux: Oracle.sh${NC}"
    echo -e "${WHITE}  • For SUSE Linux: SUSE.sh${NC}"
    echo -e "${WHITE}  • For Debian/Ubuntu: Debian-based.sh${NC}"
    echo -e "${WHITE}  • For AIX: AIX.sh${NC}"
    echo
    echo -e "${CYAN}For the correct version, please visit:${NC}"
    echo -e "${BLUE}$repo_url${NC}"
    echo
    read -p "Do you want to continue anyway? (y/N): " REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Exiting script. Please use the appropriate audit script for your system.${NC}"
        exit 1
    fi
    echo -e "${YELLOW}⚠ Warning: Continuing with $script_type audit on an incompatible system.${NC}"
    echo -e "${YELLOW}⚠ Some features may not work correctly.${NC}"
    echo
}

# Check OS compatibility
check_os_compatibility

# Check if script is running as root
if [ -x /usr/xpg4/bin/id ]; then
    CURRENT_UID=$(/usr/xpg4/bin/id -u)
else
    CURRENT_UID=$(id | sed 's/^uid=\([0-9]*\)(.*/\1/')
fi

if [ "$CURRENT_UID" -ne 0 ]; then
    echo -e "${RED}This script must be run as root.${NC}"
    exit 1
fi

# Function to calculate file hashes
calculate_file_hashes() {
    local folder_path="$1"
    local hash_file="$folder_path/file_hashes.txt"
    
    log_info "Calculating file hashes for all collected files..."
    
    # Verify folder exists
    if [ ! -d "$folder_path" ]; then
        log_error "Collection folder does not exist: $folder_path"
        return 1
    fi
    
    # Create hash file header
    {
        echo "File Hash Verification Report"
        echo "============================="
        echo "Generated on: $(date)"
        echo "Collection Folder: $folder_path"
        echo "Hash Algorithm: SHA256"
        echo ""
        echo "Format: [HASH] [FILENAME]"
        echo "======================================"
        echo ""
    } > "$hash_file"
    
    # Verify hash file was created
    if [ ! -f "$hash_file" ]; then
        log_error "Failed to create hash file: $hash_file"
        return 1
    fi
    
    # Count files before processing
    local file_count=$(find "$folder_path" -type f ! -name "file_hashes.txt" | wc -l)
    log_info "Found $file_count files to process..."
    
    # Determine which hash tool to use and set command
    local hash_cmd=""
    local hash_name=""
    local log_level="info"
    
    if command -v sha256sum >/dev/null 2>&1; then
        hash_cmd="sha256sum"
        hash_name="SHA256"
    elif command -v shasum >/dev/null 2>&1; then
        hash_cmd="shasum -a 256"
        hash_name="shasum (SHA256)"
    elif command -v digest >/dev/null 2>&1; then
        hash_cmd="digest -a sha256"
        hash_name="digest (SHA256)"
    elif command -v md5sum >/dev/null 2>&1; then
        hash_cmd="md5sum"
        hash_name="MD5"
        log_level="warn"
        echo "Note: Using MD5 (SHA256 not available)" >> "$hash_file"
    else
        echo "Error: No hash calculation tool available (sha256sum, shasum, digest, or md5sum)" >> "$hash_file"
        log_error "No hash calculation tool available"
        return 1
    fi
    
    # Calculate hashes for all files using the selected tool
    if [ "$log_level" = "warn" ]; then
        log_warn "Using $hash_name algorithm (SHA256 not available)..."
    else
        log_info "Using $hash_name algorithm..."
    fi
    
    find "$folder_path" -type f ! -name "file_hashes.txt" -print | while read file; do
        if [ -f "$file" ]; then
            $hash_cmd "$file" 2>/dev/null || echo "ERROR: Failed to hash $file"
        fi
    done >> "$hash_file"
    
    if [ "$log_level" = "warn" ]; then
        log_warn "File hashes calculated using $hash_name (SHA256 not available)"
    else
        log_info "File hashes calculated using $hash_name"
    fi
    
    # Wait for file operations to complete
    sleep 2
    
    # Add summary information
    {
        echo ""
        echo "======================================"
        echo "Hash Calculation Summary:"
        echo "Total files processed: $file_count"
        echo "Hash file location: $hash_file"
        echo "Hash file size: $(ls -lh "$hash_file" | awk '{print $5}')"
        echo "Calculation completed: $(date)"
    } >> "$hash_file"
    
    # Wait for file operations to complete
    sleep 2
    
    # Verify hash file exists and has content
    if [ -f "$hash_file" ] && [ -s "$hash_file" ]; then
        log_file_operation "Hash Calculation" "$hash_file" "success"
        log_info "Hash file size: $(ls -lh "$hash_file" | awk '{print $5}')"
        return 0
    else
        log_error "Hash file is missing or empty"
        return 1
    fi
}

# Getting hostname, IP address, and current date-time
echo ; log_info "Obtaining System Information and current date-time"
hostname=$(hostname)
# Solaris specific IP retrieval
ip_address=$(ifconfig -a | grep inet | grep -v '127.0.0.1' | awk '{print $2}' | head -1)
datetime=$(date +"%Y%m%d_%H%M%S")
echo

# Create the folder name and directory
folder_name="Solaris_${hostname}[${ip_address}]${datetime}"
log_info "Creating folder: $folder_name"
mkdir -p "$folder_name"

# Initialize log file
LOG_FILE="$folder_name/execution.log"
log_info "Log file initialized at: $LOG_FILE"

echo "DONE." ; echo

# Copy the specified files to the folder
log_info "Copying system configuration files..."
files_to_copy=(
    "/etc/passwd"
    "/etc/group"
    "/etc/shadow"
    "/etc/hosts"
    "/etc/resolv.conf"           # DNS configuration
    "/etc/release"
    "/etc/security/policy.conf"  # Security policy configuration
    "/etc/default/login"         # System login defaults
    "/etc/default/passwd"        # Password policy defaults
    "/etc/default/su"            # 'su' command defaults
    "/etc/ssh/sshd_config"       # SSH daemon configuration
    "/etc/inet/ntp.conf"         # NTP configuration
    "/etc/syslog.conf"           # System logging configuration
    "/etc/vfstab"                # File system table
    "/etc/system"                # Kernel configuration
)

for file in "${files_to_copy[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "$folder_name/" 2>/dev/null
    else
        echo "$file" >> "$folder_name/missing_files.txt"
        log_warn "Missing file: $file (logged to missing_files.txt)"
    fi
done

# Solaris specific directories
if [ -d "/etc/security" ]; then
    log_info "Copying /etc/security directory..."
    cp -r "/etc/security" "$folder_name/" 2>/dev/null
fi

echo "DONE." ; echo

# Get password change details of all users
log_info "Collecting password change status for all users..."
passwd -sa > "$folder_name/password_change.txt" 2>/dev/null
echo "DONE." ; echo

# Collect log file hierarchy
log_info "Collecting log file hierarchy from /var/adm and /var/log..."
ls -lR /var/adm /var/log > "$folder_name/file_hierarchy.txt" 2>/dev/null
echo "DONE." ; echo

log_info "Collecting login information..."
logins -x > "$folder_name/logins.txt" 2>/dev/null
who > "$folder_name/who.txt"
last > "$folder_name/last_logins.txt"
echo "DONE." ; echo

log_info "Collecting ping results..."

# Ping Hostname
log_info "Pinging hostname..."
if ping "$(hostname)" > "$folder_name/ping_hostname.txt" 2>&1; then
    log_info "✓ Ping to hostname successful"
else
    log_warn "✗ Ping to hostname failed"
fi

# Check internet connectivity
log_info "Checking internet connection..."
if ping 8.8.8.8 > "$folder_name/connectivity_check.txt" 2>&1; then
    log_info "✓ Ping successful"
else
    log_warn "✗ Ping failed (Network might be unreachable)"
fi
echo "DONE." ; echo

log_info "Collecting installed packages..."
pkginfo -l > "$folder_name/patches.txt" 2>/dev/null || pkg list > "$folder_name/patches.txt" 2>/dev/null
echo "DONE." ; echo

log_info "Collecting network port details..."
netstat -an > "$folder_name/network_ports.txt" 2>/dev/null
echo "DONE." ; echo

# Collect running processes and services
log_info "Collecting running processes and service status..."
svcs -a > "$folder_name/services_status.txt" 2>/dev/null
ps -ef > "$folder_name/processes.txt"
echo "DONE." ; echo

# Check cron jobs
log_info "Collecting cron jobs information..."
{
    echo "System-wide cron jobs (/var/spool/cron/crontabs):"
    echo "------------------------------------------------"
    if [ -d /var/spool/cron/crontabs ]; then
        ls -l /var/spool/cron/crontabs
        echo ""
        for file in /var/spool/cron/crontabs/*; do
             echo "File: $file"
             cat "$file"
             echo "-----------------------------------"
        done
    else
        echo "No /var/spool/cron/crontabs directory found."
    fi
} > "$folder_name/cronjobs.txt" 2>&1
echo "DONE." ; echo

# Create tar.gz file
log_info "Compressing collected data..."
tar cf - "$folder_name" | gzip > "${folder_name}.tar.gz"
echo "DONE." ; echo

# Calculate hashes
calculate_file_hashes "$folder_name"

log_info "Collection complete. Output file: ${folder_name}.tar.gz"
echo
