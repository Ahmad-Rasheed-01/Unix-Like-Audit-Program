#!/bin/bash


#########################################################################################
#                             USER GUIDE                                                #
#---------------------------------------------------------------------------------------#
# Version: 1.0.5                                                                        #
# Author: Ahmad Rasheed                                                                 #
# This script collects system information and compresses it to a timestamped            #
# tar.gz file.                                                                          #
#                                                                                       #
# Prerequisites:                                                                        #
# a) The script must be run as root (sudo).                                             #
# b) Make the script executable by running:                                             #
#      chmod +x Oracle.sh                                                               #
# c) Execute the script using:                                                          #
#      sudo ./Oracle.sh                                                                 #
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
# - This script is designed for RPM-based Linux systems.                                #
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
# 2026-01-05 | 1.0.5   | Ahmad Rasheed | - Added log storage functionality              #
#            |         |               | - Implemented detailed logging mechanism       #
#            |         |               | - Fixed empty services file issue              #
#            |         |               | - Added missing files tracking                 #
#---------------------------------------------------------------------------------------#
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
echo -e "${BLUE}"
echo -e "═════════════════════════════════════════════════════════════════════════════════════════════════════════════"
echo -e "                                                                                                            "
echo -e "    ${WHITE} ██████╗ ██████╗  █████╗  ██████╗██╗     ███████╗     █████╗ ██╗   ██╗██████╗ ██╗████████╗${BLUE}  "
echo -e "    ${WHITE}██╔═══██╗██╔══██╗██╔══██╗██╔════╝██║     ██╔════╝    ██╔══██╗██║   ██║██╔══██╗██║╚══██╔══╝${BLUE}  "
echo -e "    ${WHITE}██║   ██║██████╔╝███████║██║     ██║     █████╗      ███████║██║   ██║██║  ██║██║   ██║${BLUE}     "
echo -e "    ${WHITE}██║   ██║██╔══██╗██╔══██║██║     ██║     ██╔══╝      ██╔══██║██║   ██║██║  ██║██║   ██║${BLUE}     "
echo -e "    ${WHITE}╚██████╔╝██║  ██║██║  ██║╚██████╗███████╗███████╗    ██║  ██║╚██████╔╝██████╔╝██║   ██║${BLUE}     "
echo -e "    ${WHITE} ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝╚══════╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝   ╚═╝${BLUE}     "
echo -e "                                                                                                            "
echo -e "                                 ${YELLOW}🔒 A Security Audit Utility 🔒${BLUE}                                  "
echo -e "                                ${GREEN}Developed under Unix-Like Audit Program${BLUE}                             "
echo -e "                                                                                                            "
echo -e "                                                                                                            "
echo -e "    ${WHITE}Platform: Oracle Linux${BLUE}                                                                           "
echo -e "    ${WHITE}Version: 1.0.5${BLUE}                                                                                 "
echo -e "    ${WHITE}For Updates Please Visit: https://github.com/Ahmad-Rasheed-01/Unix-Like-Audit-Program${BLUE}          "
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
    elif command -v md5sum >/dev/null 2>&1; then
        hash_cmd="md5sum"
        hash_name="MD5"
        log_level="warn"
        echo "Note: Using MD5 (SHA256 not available)" >> "$hash_file"
    else
        echo "Error: No hash calculation tool available (sha256sum, shasum, or md5sum)" >> "$hash_file"
        log_error "No hash calculation tool available"
        return 1
    fi
    
    # Calculate hashes for all files using the selected tool
    if [ "$log_level" = "warn" ]; then
        log_warn "Using $hash_name algorithm (SHA256 not available)..."
    else
        log_info "Using $hash_name algorithm..."
    fi
    
    find "$folder_path" -type f ! -name "file_hashes.txt" -print0 | while IFS= read -r -d '' file; do
        $hash_cmd "$file" 2>/dev/null || echo "ERROR: Failed to hash $file"
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

# Function to detect OS and validate script compatibility
check_os_compatibility() {
    local detected_os="Unknown"
    local script_type="Oracle Linux"
    local repo_url="https://github.com/Ahmad-Rasheed-01/Unix-Like-Audit-Program"
    
    # Detect operating system
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            "oracle"|"ol")
                detected_os="Oracle Linux"
                echo -e "${GREEN}✓ OS Detection: $detected_os detected${NC}"
                echo -e "${GREEN}✓ Script Compatibility: This script is optimized for your system${NC}"
                echo
                read -p "Do you want to continue with the collection? (Y/n): " REPLY
                if [[ $REPLY =~ ^[Nn]$ ]]; then
                    echo -e "${RED}Collection cancelled by user.${NC}"
                    exit 0
                fi
                echo -e "${CYAN}Continuing with $script_type collection...${NC}"
                echo
                return 0
                ;;
            "rhel"|"centos"|"fedora"|"rocky"|"almalinux")
                detected_os="RedHat/RHEL Compatible"
                echo -e "${YELLOW}⚠ OS Detection: $detected_os detected${NC}"
                echo -e "${YELLOW}⚠ Recommendation: Consider using RedHat.sh for better compatibility${NC}"
                echo -e "${CYAN}However, this script should work as Oracle Linux is RHEL-compatible${NC}"
                echo
                read -p "Do you want to continue with the collection? (Y/n): " REPLY
                if [[ $REPLY =~ ^[Nn]$ ]]; then
                    echo -e "${RED}Collection cancelled by user.${NC}"
                    exit 0
                fi
                echo -e "${CYAN}Continuing with $script_type collection...${NC}"
                echo
                return 0
                ;;
            "ubuntu"|"debian")
                detected_os="Debian/Ubuntu"
                ;;
            "sles"|"opensuse"|"opensuse-leap"|"opensuse-tumbleweed")
                detected_os="SUSE Linux"
                ;;
            "aix")
                detected_os="AIX"
                ;;
            *)
                detected_os="$NAME ($ID)"
                ;;
        esac
    elif [ -f /etc/oracle-release ]; then
        detected_os="Oracle Linux"
        echo -e "${GREEN}✓ OS Detection: $detected_os detected${NC}"
        echo -e "${GREEN}✓ Script Compatibility: This script is optimized for your system${NC}"
        echo
        read -p "Do you want to continue with the collection? (Y/n): " REPLY
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            echo -e "${RED}Collection cancelled by user.${NC}"
            exit 0
        fi
        echo -e "${CYAN}Continuing with $script_type collection...${NC}"
        echo
        return 0
    elif [ -f /etc/redhat-release ]; then
        detected_os="RedHat/RHEL Compatible"
        echo -e "${YELLOW}⚠ OS Detection: $detected_os detected${NC}"
        echo -e "${YELLOW}⚠ This appears to be a RHEL-compatible system${NC}"
        echo
        read -p "Do you want to continue with the collection? (Y/n): " REPLY
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            echo -e "${RED}Collection cancelled by user.${NC}"
            exit 0
        fi
        echo -e "${CYAN}Continuing with $script_type collection...${NC}"
        echo
        return 0
    elif command -v rpm >/dev/null 2>&1; then
        detected_os="RPM-based system"
        echo -e "${YELLOW}⚠ OS Detection: $detected_os detected${NC}"
        echo -e "${YELLOW}⚠ This appears to be an RPM-based system, proceeding with caution${NC}"
        echo
        read -p "Do you want to continue with the collection? (Y/n): " REPLY
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            echo -e "${RED}Collection cancelled by user.${NC}"
            exit 0
        fi
        echo -e "${CYAN}Continuing with $script_type collection...${NC}"
        echo
        return 0
    fi
    
    # If we reach here, the OS is not compatible
    echo -e "${RED}✗ OS Detection: $detected_os detected${NC}"
    echo -e "${RED}✗ Script Compatibility: This script is designed for $script_type systems${NC}"
    echo -e "${YELLOW}Please use the appropriate script for your operating system:${NC}"
    echo -e "${WHITE}  • For RedHat/RHEL: RedHat.sh${NC}"
    echo -e "${WHITE}  • For SUSE Linux: SUSE.sh${NC}"
    echo -e "${WHITE}  • For AIX: AIX.sh${NC}"
    echo -e "${WHITE}  • For Debian/Ubuntu: Debian-based.sh${NC}"
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

# Perform OS compatibility check
check_os_compatibility

# Check if script is running as root
if [ "$EUID" -ne 0 ]; then
    log_error "This script must be run as root."
    exit 1
fi

# Getting hostname, IP address, and current date-time
echo ; log_info "Obtaining system details and current date-time"
hostname=$(hostname)
ip_address=$(hostname -I | awk '{print $1}')
datetime=$(date +"%Y%m%d_%H%M%S")
echo

# Create the folder name and directory
folder_name="Oracle_${hostname}[${ip_address}]${datetime}"
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
    "/etc/login.defs"
    "/etc/sudoers"
    "/etc/shadow"
    "/etc/hosts"
    "/etc/resolv.conf"
    "/etc/os-release"
    "/etc/pam.d/system-auth"
    "/etc/pam.d/password-auth"
    "/etc/security/pwquality.conf"
    "/etc/audit/auditd.conf"
    "/etc/audit/rules.d/audit.rules"
    "/etc/security/limits.conf"
)

for file in "${files_to_copy[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "$folder_name/" 2>/dev/null
    else
        echo "$file" >> "$folder_name/missing_files.txt"
        log_warn "Missing file: $file (logged to missing_files.txt)"
    fi
done

# Collect sudoers.d directory
if [ -d "/etc/sudoers.d" ]; then
    log_info "Copying /etc/sudoers.d directory..."
    cp -r "/etc/sudoers.d" "$folder_name/" 2>/dev/null
else
    log_warn "Directory /etc/sudoers.d not found"
fi
echo "DONE." ; echo

# Get password change details of all users
log_info "Collecting password change status for all users..."
for user in $(cut -d: -f1 /etc/passwd); do passwd -S "$user"; done > "$folder_name/password_change.txt"
echo "DONE." ; echo

# Collect log file hierarchy
log_info "Collecting log file hierarchy from /var/log..."
ls -lR /var/log > "$folder_name/file_hierarchy.txt"
echo "DONE." ; echo

log_info "Collecting login information..."
lslogins > "$folder_name/logins.txt"
w > "$folder_name/who.txt"
echo "DONE." ; echo

log_info "Collecting ping results..."

# Ping Hostname
log_info "Pinging hostname..."
if ping -c 4 "$(hostname)" > "$folder_name/ping_hostname.txt" 2>&1; then
    log_info "✓ Ping to hostname successful"
else
    log_warn "✗ Ping to hostname failed"
fi

# Check internet connectivity
log_info "Checking internet connection..."
if ping -c 4 8.8.8.8 > "$folder_name/connectivity_check.txt" 2>&1; then
    log_info "✓ Ping successful"
else
    log_warn "✗ Ping failed (Network might be unreachable)"
fi
echo "DONE." ; echo

log_info "Collecting applied patches detail..."
rpm -qai > "$folder_name/patches.txt" 2>/dev/null || echo "RPM not available on this system" > "$folder_name/patches.txt"
echo "DONE." ; echo

log_info "Collecting network port details..."
netstat -tuln > "$folder_name/network_ports.txt" 2>/dev/null || ss -tuln > "$folder_name/network_ports.txt"
echo "DONE." ; echo

# Collect running processes and services
log_info "Collecting running processes and service status..."

# Collect services
if command -v systemctl &> /dev/null; then
    systemctl list-units --type=service --all > "$folder_name/services_status.txt" 2>&1
elif command -v service &> /dev/null; then
    service --status-all > "$folder_name/services_status.txt" 2>&1
elif command -v chkconfig &> /dev/null; then
    chkconfig --list > "$folder_name/services_status.txt" 2>&1
else
    echo "No service manager found (systemctl, service, or chkconfig)." > "$folder_name/services_status.txt"
    log_warn "Service status collection failed: No service manager found."
fi

# Collect processes
ps -ef > "$folder_name/processes.txt" 2>&1
echo "DONE." ; echo

# Check NTP sync status
log_info "Collecting NTP sync details..."
if command -v chronyc &> /dev/null; then
    chronyc tracking > "$folder_name/ntp_sync_status.txt"
elif command -v ntpq &> /dev/null; then
    ntpq -p > "$folder_name/ntp_sync_status.txt"
else
    echo "NTP sync status check failed: Neither chronyc nor ntpq is available." > "$folder_name/ntp_sync_status.txt"
fi
echo "DONE." ; echo

# Check cron jobs
log_info "Collecting cron jobs information..."
{
    echo "System-wide cron jobs (/etc/crontab):"
    echo "------------------------------------"
    if [ -f /etc/crontab ]; then
        cat /etc/crontab
    else
        echo "No /etc/crontab file found."
    fi

    echo -e "\nCron jobs in /etc/cron.* directories:"
    echo "-------------------------------------"
    for cron_dir in /etc/cron.*; do
        if [ -d "$cron_dir" ]; then
            echo -e "\nDirectory: $cron_dir"
            for file in "$cron_dir"/*; do
                if [ -f "$file" ]; then
                    echo -e "\nFile: $file"
                    cat "$file"
                fi
            done
        fi
    done

    echo -e "\nUser-specific cron jobs:"
    echo "-------------------------"
    for user in $(cut -d: -f1 /etc/passwd); do
        echo -e "\nCron jobs for user: $user"
        crontab -u "$user" -l 2>/dev/null || echo "No crontab for $user"
    done
} > "$folder_name/cron_jobs.txt"
echo "DONE." ; echo

# Collect user home directory information
log_info "Collecting user home directory information..."
{
    echo "User Home Directory Information"
    echo "==============================="
    echo
    
    first_user=true
    while IFS=: read -r username password uid gid gecos home_dir shell; do
        # Add separator before each user (except the first one)
        if [ "$first_user" = true ]; then
            first_user=false
        else
            echo "----------------------------------------"
            echo
        fi
        
        echo "User: $username (UID: $uid, GID: $gid)"
        echo "Home Directory: $home_dir"
        echo "Shell: $shell"
        
        if [ -d "$home_dir" ]; then
            echo "Directory exists: Yes"
            
            # Get stat information with timeout
            echo "Stat information:"
            timeout 10 stat "$home_dir" 2>/dev/null || echo "[Timeout or access denied]"
        else
            echo "Directory exists: No"
        fi
        
        echo
    done < /etc/passwd
} > "$folder_name/user_home_dir.txt"
echo "DONE." ; echo

# Calculate file hashes before creating tar
if calculate_file_hashes "$folder_name"; then
    log_info "File hash calculation completed successfully"
    # Small delay to ensure file system operations are complete
    sleep 2
    # Verify hash file is included in the collection
    if [ -f "$folder_name/file_hashes.txt" ]; then
        log_info "Hash file verified in collection folder"
    else
        log_warn "Hash file not found in collection folder"
    fi
else
    log_error "File hash calculation failed"
fi
echo

# Create tar file
tar_file="${folder_name}.tar.gz"
log_info "Creating tar file: $tar_file"
tar -czvf "$tar_file" "$folder_name" >/dev/null
echo "DONE."

# Verify hash file is included in the tar archive
log_info "Verifying hash file inclusion in tar archive..."
if tar -tzf "$tar_file" | grep -q "file_hashes.txt"; then
    log_info "Hash file successfully included in tar archive"
else
    log_warn "Hash file not found in tar archive"
fi
echo

log_info "Script execution completed. All files and outputs are saved in $tar_file."
log_info "The tar file ($tar_file) is ready to be copied to secure storage."
