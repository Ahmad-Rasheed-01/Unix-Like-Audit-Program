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
#      chmod +x AIX.sh                                                                 #
# c) Execute the script using:                                                         #
#      sudo ./AIX.sh                                                                   #
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
# - This script is designed for AIX systems.                                           #
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
echo -e "${BLUE}"
echo -e "════════════════════════════════════════════════════════════════════════════════════════════════════════════"
echo -e "                                                                                                            "
echo -e "    ${WHITE} █████╗ ██╗██╗  ██╗      █████╗ ██╗   ██╗██████╗ ██╗████████╗${BLUE}                     "
echo -e "    ${WHITE}██╔══██╗██║╚██╗██╔╝     ██╔══██╗██║   ██║██╔══██╗██║╚══██╔══╝${BLUE}                     "
echo -e "    ${WHITE}███████║██║ ╚███╔╝      ███████║██║   ██║██║  ██║██║   ██║${BLUE}                        "
echo -e "    ${WHITE}██╔══██║██║ ██╔██╗      ██╔══██║██║   ██║██║  ██║██║   ██║${BLUE}                        "
echo -e "    ${WHITE}██║  ██║██║██╔╝ ██╗     ██║  ██║╚██████╔╝██████╔╝██║   ██║${BLUE}                        "
echo -e "    ${WHITE}╚═╝  ╚═╝╚═╝╚═╝  ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝   ╚═╝${BLUE}                        "
echo -e "                                                                                                            "
echo -e "                 ${YELLOW}🔒 A Security Audit Utility 🔒${BLUE}                                  "
echo -e "                ${GREEN}Developed under Unix-Like Audit Program${BLUE}                             "
echo -e "                                                                                                            "
echo -e "                                                                                                            "
echo -e "    ${WHITE}Platform: IBM AIX${BLUE}                                                                                 "
echo -e "    ${WHITE}Version: 1.0.4${BLUE}                                                                                 "
echo -e "    ${WHITE}For Updates Please Visit: https://github.com/Ahmad-Rasheed-01/Unix-like-Audit-Program${BLUE}          "
echo -e "                                                                                                            "
echo -e "════════════════════════════════════════════════════════════════════════════════════════════════════════════"
echo -e "${NC}"
echo

# Function to check OS compatibility
check_os_compatibility() {
    local detected_os="Unknown"
    local script_type="AIX"
    local repo_url="https://github.com/Ahmad-Rasheed-01/Unix-like-Audit-Program"
    
    echo -e "${CYAN}Checking OS compatibility...${NC}"
    
    # Check if it's AIX system
    if uname -s | grep -qi "aix"; then
        detected_os="AIX"
        aix_version=$(oslevel 2>/dev/null || uname -v)
        echo -e "${GREEN}✓ OS Detection: $detected_os detected (Version: $aix_version)${NC}"
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
    fi
    
    # Check for other distributions
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            "rhel"|"centos"|"fedora"|"rocky"|"almalinux")
                detected_os="RedHat/RHEL Compatible"
                ;;
            "oracle")
                detected_os="Oracle Linux"
                ;;
            "sles"|"opensuse"|"opensuse-leap"|"opensuse-tumbleweed")
                detected_os="SUSE Linux"
                ;;
            "ubuntu"|"debian")
                detected_os="Debian/Ubuntu"
                ;;
            *)
                detected_os="$NAME ($ID)"
                ;;
        esac
    elif [ -f /etc/redhat-release ]; then
        detected_os="RedHat/RHEL Compatible"
    elif [ -f /etc/oracle-release ]; then
        detected_os="Oracle Linux"
    elif [ -f /etc/SuSE-release ] || [ -f /etc/SUSE-brand ]; then
        detected_os="SUSE Linux"
    elif [ -f /etc/debian_version ]; then
        detected_os="Debian/Ubuntu"
    fi
    
    # If we reach here, the OS is not compatible
    echo -e "${RED}✗ OS Detection: $detected_os detected${NC}"
    echo -e "${RED}✗ Script Compatibility: This script is designed for $script_type systems${NC}"
    echo -e "${YELLOW}Please use the appropriate script for your operating system:${NC}"
    echo -e "${WHITE}  • For RedHat/RHEL: RedHat.sh${NC}"
    echo -e "${WHITE}  • For SUSE Linux: SUSE.sh${NC}"
    echo -e "${WHITE}  • For Oracle Linux: Oracle.sh${NC}"
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
    
    echo "Calculating file hashes for all collected files..."
    
    # Verify folder exists
    if [ ! -d "$folder_path" ]; then
        echo "Error: Collection folder does not exist: $folder_path"
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
        echo "Error: Failed to create hash file: $hash_file"
        return 1
    fi
    
    # Count files before processing
    local file_count=$(find "$folder_path" -type f ! -name "file_hashes.txt" | wc -l)
    echo "Found $file_count files to process..."
    
    # Determine which hash tool to use and set command
    local hash_cmd=""
    local hash_name=""
    local log_level="info"
    local note_msg=""
    
    if command -v sha256sum >/dev/null 2>&1; then
        hash_cmd="sha256sum"
        hash_name="SHA256"
    elif command -v shasum >/dev/null 2>&1; then
        hash_cmd="shasum -a 256"
        hash_name="shasum (SHA256)"
    elif command -v digest >/dev/null 2>&1; then
        hash_cmd="digest -a sha256"
        hash_name="AIX digest (SHA256)"
        note_msg="Note: Using AIX digest command (SHA256)"
    elif command -v md5sum >/dev/null 2>&1; then
        hash_cmd="md5sum"
        hash_name="MD5"
        log_level="warn"
        note_msg="Note: Using MD5 (SHA256 not available)"
    else
        echo "Error: No hash calculation tool available (sha256sum, shasum, digest, or md5sum)" >> "$hash_file"
        echo "Error: No hash calculation tool available"
        return 1
    fi
    
    # Add note to hash file if needed
    if [ -n "$note_msg" ]; then
        echo "$note_msg" >> "$hash_file"
    fi
    
    # Calculate hashes for all files using the selected tool
    if [ "$log_level" = "warn" ]; then
        echo "Warning: Using $hash_name algorithm (SHA256 not available)..."
    else
        echo "Using $hash_name algorithm..."
    fi
    
    find "$folder_path" -type f ! -name "file_hashes.txt" -print0 | while IFS= read -r -d '' file; do
        $hash_cmd "$file" 2>/dev/null || echo "ERROR: Failed to hash $file"
    done >> "$hash_file"
    
    if [ "$log_level" = "warn" ]; then
        echo "Warning: File hashes calculated using $hash_name (SHA256 not available)"
    else
        echo "File hashes calculated using $hash_name"
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
        echo "Hash file size: $(ls -lh "$hash_file" | awk '{print $5}')"
        echo "DONE." ; echo
        return 0
    else
        echo "Error: Hash file is missing or empty"
        return 1
    fi
}

# Get hostname, IP address, and current date-time
echo ; echo "Obtaining system hostname, IP address, and current date-time"
hostname=$(hostname)
ip_address=$(ifconfig -a | grep 'inet ' | awk '{print $2}' | head -n 1)
datetime=$(date +"%Y%m%d_%H%M%S")
echo

# Create the folder name and directory

folder_name="AIX_${hostname}[${ip_address}]${datetime}"
echo "Creating folder: $folder_name"
mkdir -p "$folder_name"
echo "DONE." ; echo

# Copy the system files to the folder
echo "Copying system configuration files..."
files_to_copy=(
    /etc/release /etc/os-release /etc/group /etc/passwd /etc/shadow /etc/sudoers
    /etc/security/audit/config /etc/security/login.cfg /etc/security/group
    /etc/security/passwd /etc/security/lastlog /etc/security/user
    /etc/security/login.cfg /etc/security/passwd_policy /usr/lib/security/passwd_policy
    /etc/security/userattr /etc/pam.conf /etc/hosts.equiv /etc/hosts.rhosts
    /etc/hosts.netrc /etc/syslog.conf /etc/rc.firewall /var/adm/cron/cron.allow
    /var/adm/cron/cron.deny /etc/at.allow /etc/at.deny
)
echo "DONE." ; echo

# Get password change details of all users
echo "Collecting password change status for all users..."
for file in "${files_to_copy[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "$folder_name/" 2>/dev/null
    else
        echo "$file not found" >> "$folder_name/missing_files.txt"
    fi
done
echo "DONE." ; echo

echo "Collecting user groups information..."
lsgroup ALL > "$folder_name/lsgroup.txt" 2>/dev/null
echo "DONE." ; echo

echo "Collecting running processes and service status..."
lsrc -all > "$folder_name/services_status.txt" 2>/dev/null
ps -ef > "$folder_name/processes.txt"
#ls -lR / > "$folder_name/file_hierarchy.txt"
echo "DONE." ; echo

echo "Collecting details of installed programs"
lslpp -L > "$folder_name/installed_programs.txt" 2>/dev/null
echo "DONE." ; echo

cat /var/log/messages | grep su > "$folder_name/sulogs.txt" 2>/dev/null || echo "No su logs found" > "$folder_name/sulogs.txt"
echo "DONE." ; echo

echo "Collecting log file hierarchy from /var/log..."
ls -lR /var/log > "$folder_name/log_directory.txt" 2>/dev/null || echo "No audit logs found" > "$folder_name/log_directory.txt"
echo "DONE." ; echo

echo "Collecting network port details..."
netstat -an > "$folder_name/network_ports.txt" 2>/dev/null || echo "Netstat not available" > "$folder_name/network_ports.txt"
echo "DONE." ; echo

echo "Getting host firewall details"
ipfw list > "$folder_name/ipfw_list.txt" 2>/dev/null || echo "ipfw not available" > "$folder_name/ipfw_list.txt"
echo "DONE." ; echo

echo "Collecting ping results..."
ping "$(hostname)" -c 4 > "$folder_name/ping_hostname.txt"
ping 8.8.8.8 -c 4 > "$folder_name/ping_google.txt"
echo "DONE." ; echo

echo "Collecting installed programs detail..."
lslpp -l > "$folder_name/packages.txt" 2>/dev/null || echo "lslpp not available" > "$folder_name/packages.txt"
echo "DONE." ; echo

# Check NTP sync status
echo "Collecting NTP sync details..."
if command -v ntpq &> /dev/null; then
    ntpq -p > "$folder_name/ntp_sync_status.txt"
else
    echo "NTP sync status check failed: ntpq not available." > "$folder_name/ntp_sync_status.txt"
fi

ntpdate -d > "$folder_name/ntpdate.txt" 2>/dev/null || echo "ntpdate not available" > "$folder_name/ntpdate.txt"
echo "DONE." ; echo

# Check cron jobs
echo "Collecting cron jobs information..."
{
    echo "Cron jobs for allowed users (/var/adm/cron/cron.allow):"
    if [ -f /var/adm/cron/cron.allow ]; then
        cat /var/adm/cron/cron.allow
    else
        echo "No cron.allow file found."
    fi

    echo -e "\nCron jobs for denied users (/var/adm/cron/cron.deny):"
    if [ -f /var/adm/cron/cron.deny ]; then
        cat /var/adm/cron/cron.deny
    else
        echo "No cron.deny file found."
    fi

    echo -e "\nUser-specific cron jobs:"
    for user in $(cut -d: -f1 /etc/passwd); do
        echo -e "\nCron jobs for user: $user"
        crontab -l -u "$user" 2>/dev/null || echo "No crontab for $user"
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
            
            # Get stat information (AIX version)
            echo "Stat information:"
            stat "$home_dir" 2>/dev/null || echo "[Access denied or stat failed]"
        else
            echo "Directory exists: No"
        fi
        
        echo
    done < /etc/passwd
} > "$folder_name/user_home_dir.txt"
echo "DONE." ; echo

# Calculate file hashes before creating tar
if calculate_file_hashes "$folder_name"; then
    echo -e "${GREEN}✓ File hash calculation completed successfully${NC}"
    # Small delay to ensure file system operations are complete
    sleep 1
    # Verify hash file is included in the collection
    if [ -f "$folder_name/file_hashes.txt" ]; then
        echo -e "${GREEN}✓ Hash file verified in collection folder${NC}"
    else
        echo -e "${RED}✗ Warning: Hash file not found in collection folder${NC}"
    fi
else
    echo -e "${RED}✗ File hash calculation failed${NC}"
fi
echo

# Create tar file
tar_file="${folder_name}.tar.gz"
echo "Creating tar file: $tar_file"
tar -czvf "$tar_file" "$folder_name" >/dev/null
echo "DONE."

# Verify hash file is included in the tar archive
echo "Verifying hash file inclusion in tar archive..."
if tar -tzf "$tar_file" | grep -q "file_hashes.txt"; then
    echo -e "${GREEN}✓ Hash file successfully included in tar archive${NC}"
else
    echo -e "${RED}✗ Warning: Hash file not found in tar archive${NC}"
fi
echo

echo -e "${GREEN}Script execution completed. All files and outputs are saved in ${NC}${BLUE}$tar_file${NC}${GREEN}.${NC}"
echo -e "${CYAN}The tar file (${tar_file}) is ready to be copied to secure storage.${NC}"
