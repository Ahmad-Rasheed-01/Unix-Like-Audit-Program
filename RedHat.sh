#!/bin/bash


########################################################################################
#                             USER GUIDE                                               #
#--------------------------------------------------------------------------------------#
# Version: 1.0.4                                                                       #
# Author: Ahmad Rasheed                                                                #
# This script collects system information and compresses it to a timestamped           #
# tar.gz file.                                                                         #
#                                                                                      #
# Prerequisites:                                                                       #
# a) The script must be run as root (sudo).                                            #
# b) Make the script executable by running:                                            #
#      chmod +x RedHat.sh                                                              #
# c) Execute the script using:                                                         #
#      sudo ./RedHat.sh                                                                #
# d) The script automatically creates a tar.gz file in the current directory.          #
# e) Share the generated tar.gz file as needed.                                        #
#                                                                                      # 
#                                                                                      #
#--------------------------------------------------------------------------------------#
#                       Operational Instructions                                       #
#--------------------------------------------------------------------------------------#
# a) Scrutinize the contents of the script to ensure that it does not contain          #
#    any statements, commands or any other code that might negatively influence        #
#    the environment(s) in either a security or operational way.                       #
# b) Test the script on the test environment to ensure that it does not contain        #
#    any statements, commands or any other code that might negatively influence        #
#    the environment(s) in either a security or operational way.                       #
# c) The final responsibility for executing this script lies with the executor.        #
# d) It is advised to execute the script during off-peak hours.                        #
#                                                                                      #
# Notes:                                                                               #
# - This script is designed for RedHat-based Linux systems (RHEL, CentOS, Fedora, etc.) #
# - Ensure you have sufficient permissions to read system files.                       #
# - Some commands/files may not be available depending on the OS version.              #
# - This script is READ-ONLY and does not modify any system states or configurations.  #
# - For updates, visit: https://github.com/Ahmad-Rasheed-01/Unix-like-Audit-Program    #
#                                                                                      #
########################################################################################


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
echo -e "${CYAN}"
echo -e "══════════════════════════════════════════════════════════════════════════════════════════════════════════════"
echo -e "                                                                                                            "
echo -e "    ${WHITE}██████╗ ███████╗██████╗ ██╗  ██╗ █████╗ ████████╗     █████╗ ██╗   ██╗██████╗ ██╗████████╗${CYAN}     "
echo -e "    ${WHITE}██╔══██╗██╔════╝██╔══██╗██║  ██║██╔══██╗╚══██╔══╝    ██╔══██╗██║   ██║██╔══██╗██║╚══██╔══╝${CYAN}     "
echo -e "    ${WHITE}██████╔╝█████╗  ██║  ██║███████║███████║   ██║       ███████║██║   ██║██║  ██║██║   ██║${CYAN}        "
echo -e "    ${WHITE}██╔══██╗██╔══╝  ██║  ██║██╔══██║██╔══██║   ██║       ██╔══██║██║   ██║██║  ██║██║   ██║${CYAN}        "
echo -e "    ${WHITE}██║  ██║███████╗██████╔╝██║  ██║██║  ██║   ██║       ██║  ██║╚██████╔╝██████╔╝██║   ██║${CYAN}        "
echo -e "    ${WHITE}╚═╝  ╚═╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝   ╚═╝${CYAN}        "
echo -e "                                                                                                            "
echo -e "                                 ${YELLOW}🔒 A Security Audit Utility 🔒${CYAN}                                  "
echo -e "                                ${GREEN}Developed under Unix-Like Audit Program${CYAN}                             "
echo -e "                                                                                                            "
echo -e "                                                                                                            "
echo -e "    ${WHITE}Platform: RedHat${CYAN}                                                                                 "
echo -e "    ${WHITE}Version: 1.0.4${CYAN}                                                                                 "
echo -e "    ${WHITE}For Updates Please Visit: https://github.com/Ahmad-Rasheed-01/Unix-Like-Audit-Program${CYAN}          "
echo -e "                                                                                                            "
echo -e "══════════════════════════════════════════════════════════════════════════════════════════════════════════════"
echo -e "${NC}"
echo

# Function to detect OS and validate script compatibility
check_os_compatibility() {
    local detected_os="Unknown"
    local script_type="RedHat/RHEL"
    local repo_url="https://github.com/Ahmad-Rasheed-01/Unix-Like-Audit-Program"
    
    # Detect operating system
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            "rhel"|"centos"|"fedora"|"rocky"|"almalinux")
                detected_os="RedHat/RHEL Compatible"
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
                ;;
            "oracle")
                detected_os="Oracle Linux"
                echo -e "${YELLOW}⚠ OS Detection: $detected_os detected${NC}"
                echo -e "${YELLOW}⚠ Recommendation: Consider using Oracle.sh for better compatibility${NC}"
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
            *)
                detected_os="$NAME ($ID)"
                ;;
        esac
    elif [ -f /etc/redhat-release ]; then
        detected_os="RedHat/RHEL Compatible"
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
    fi
    
    # If we reach here, the OS is not compatible
    echo -e "${RED}✗ OS Detection: $detected_os detected${NC}"
    echo -e "${RED}✗ Script Compatibility: This script is designed for $script_type systems${NC}"
    echo -e "${YELLOW}Please use the appropriate script for your operating system:${NC}"
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
if [ "$EUID" -ne 0 ]; then
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
    
    # Force file system sync to ensure data is written
    sync
    
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
    
    # Final sync to ensure all data is written
    sync
    
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
echo ; echo "Obtaining system hostname, IP address, and current date-time"
hostname=$(hostname)
ip_address=$(hostname -I | awk '{print $1}')
datetime=$(date +"%Y%m%d_%H%M%S")
echo

# Create the folder name and directory
folder_name="RedHat_${hostname}[${ip_address}]${datetime}"
echo "Creating folder: $folder_name"
mkdir -p "$folder_name"
echo "DONE." ; echo

# Copy the specified files to the folder
echo "Copying system configuration files..."
cp /etc/passwd /etc/group /etc/login.defs /etc/sudoers /etc/shadow /etc/hosts /etc/resolv.conf /etc/os-release "$folder_name" 2>/dev/null
cp /etc/pam.d/system-auth /etc/pam.d/password-auth /etc/security/pwquality.conf "$folder_name" 2>/dev/null
cp /etc/audit/auditd.conf /etc/audit/rules.d/audit.rules "$folder_name" 2>/dev/null
#cp -r /etc/cron.d*
echo "DONE." ; echo

# Get password change details of all users
echo "Collecting password change status for all users..."
for user in $(cut -d: -f1 /etc/passwd); do passwd -S "$user"; done > "$folder_name/password_change.txt"
echo "DONE." ; echo

# Collect log file hierarchy
echo "Collecting log file hierarchy from /var/log..."
ls -lR /var/log > "$folder_name/file_hierarchy.txt"
echo "DONE." ; echo

echo "Collecting login information..."
lslogins > "$folder_name/logins.txt"
w > "$folder_name/who.txt"
#timedatectl status | grep "NTP synchronized" > "$folder_name/ntp_sync_status.txt"
# crontab -l > "$folder_name/cronjobs.txt" 2>/dev/null || echo "No crontab found" > "$folder_name/cronjobs.txt"
echo "DONE." ; echo

echo "Collecting ping results..."
ping -c 4 "$(hostname)" > "$folder_name/ping_hostname.txt"
ping -c 4 8.8.8.8 > "$folder_name/ping_google.txt"
echo "DONE." ; echo

echo "Collecting applied patches detail..."
rpm -qai > "$folder_name/patches.txt" 2>/dev/null || echo "RPM not available on this system" > "$folder_name/patches.txt"
echo "DONE." ; echo

echo "Collecting network port details..."
netstat -tuln > "$folder_name/network_ports.txt" 2>/dev/null || ss -tuln > "$folder_name/network_ports.txt"
echo "DONE." ; echo

# Collect running processes and services
echo "Collecting running processes and service status..."
systemctl list-units --type=service --all > "$folder_name/services_status.txt"
ps -ef > "$folder_name/processes.txt"
echo "DONE." ; echo

# Check NTP sync status
echo "Collecting NTP sync details..."
if command -v chronyc &> /dev/null; then
    chronyc tracking > "$folder_name/ntp_sync_status.txt"
elif command -v ntpq &> /dev/null; then
    ntpq -p > "$folder_name/ntp_sync_status.txt"
else
    echo "NTP sync status check failed: Neither chronyc nor ntpq is available." > "$folder_name/ntp_sync_status.txt"
fi
echo "DONE." ; echo

# Check cron jobs
echo "Collecting cron jobs information..."
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
echo "Collecting user home directory information..."
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

# Calculate file hashes before creating tar file
if calculate_file_hashes "$folder_name"; then
    log_info "✓ File hash calculation completed successfully"
    # Small delay to ensure file system operations are complete
    sleep 1
    # Verify hash file is included in the collection
    if [ -f "$folder_name/file_hashes.txt" ]; then
        log_info "✓ Hash file verified in collection folder"
    else
        log_warn "✗ Warning: Hash file not found in collection folder"
    fi
else
    log_error "✗ File hash calculation failed"
fi

# Create tar file
tar_file="${folder_name}.tar.gz"
echo "Creating tar file: $tar_file"
if tar -czvf "$tar_file" "$folder_name" >/dev/null; then
    echo "Tar file created successfully."
    
    # Verify hash file is included in the tar archive
    echo "Verifying hash file inclusion in tar archive..."
    if tar -tzf "$tar_file" | grep -q "file_hashes.txt"; then
        echo "✓ Hash file successfully included in tar archive"
    else
        echo "✗ Warning: Hash file not found in tar archive"
    fi
else
    echo "Failed to create tar file"
    exit 1
fi
echo "DONE." ; echo

echo -e "${GREEN}Script execution completed. All files and outputs are saved in ${NC}${BLUE}$tar_file${NC}${GREEN}.${NC}"
echo -e "${CYAN}The tar file (${tar_file}) is ready to be copied to secure storage.${NC}"

