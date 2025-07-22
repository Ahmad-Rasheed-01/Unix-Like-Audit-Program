#!/bin/bash


#####################################################################################
#                             USER GUIDE                                            #
#-----------------------------------------------------------------------------------#
# This script collects system information and saves it in a timestamped folder.     #
#                                                                                   #
# Prerequisites:                                                                    #
# a) The script must be run as root (sudo).                                         #
# b) Make the script executable by running:                                         #
#      chmod +x linux.sh                                                            #
# c) Execute the script using:                                                      #
#      sudo ./script_name.sh                                                        #
# d) After execution, create a tar file of the output folder:                       #
#      tar -czvf output_folder_name.tar.gz output_folder_name                       #
# e) Share the generated tar file as needed.                                        #
#                                                                                   #  
#                                                                                   #
#-----------------------------------------------------------------------------------#
#                       Operational Instructions                                    #
#-----------------------------------------------------------------------------------#
# a) Scrutinize the contents of the script to ensure that it does not contain       #
#    any statements, commands or any other code that might negatively influence     #
#    the environment(s) in either a security or operational way.                    #
# b) Test the script on the test environment to ensure that it does not contain     #
#    any statements, commands or any other code that might negatively influence     #
#    the environment(s) in either a security or operational way.                    #
# c) The final responsibility for executing this script lies with the executor.     #
# d) It is advised to execute the script during off-peak hours.                     #
#                                                                                   #
# Notes:                                                                            #
# - This script is designed for AIX systems.                                        #
# - Ensure you have sufficient permissions to read system files.                    #
# - Some commands/ files may not be available depending on the OS version.          #
#                                                                                   #
#####################################################################################


# color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[1;34m'
NC='\033[0m'

# Check if script is running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}This script must be run as root.${NC}"
    exit 1
fi

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

# Create tar file
tar_file="${folder_name}.tar.gz"
echo "Creating tar file: $tar_file"
tar -czvf "$tar_file" "$folder_name" >/dev/null
echo "DONE." ; echo

echo -e "${GREEN}Script execution completed. All files and outputs are saved in ${NC}${BLUE}$tar_file${NC}${GREEN}.${NC}"
echo -e "${CYAN}The tar file (${tar_file}) is ready to be copied to secure storage.${NC}"
