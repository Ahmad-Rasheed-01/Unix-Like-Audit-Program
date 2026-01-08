# Unix-Like Audit Collection Checklist

This document serves as a checklist for creating audit collection scripts for various Unix-like operating systems.

## Collection Items

| Category | Item Description | RedHat | Oracle | Debian / Ubuntu | SUSE | AIX |
|----------|------------------|--------|--------|-----------------|------|-----|
| **System Info** | Basic Host Info | `hostname`, `uptime`, `uname -r` | `hostname`, `uptime`, `uname -r` | `hostname`, `uptime`, `uname -r` | `hostname`, `uptime`, `uname -r` | `hostname`, `uptime`, `uname -r` |
| | IP Addresses | `hostname -I` | `hostname -I` | `hostname -I` | `hostname -I` | `ifconfig -a` |
| | OS Release Info | `cat /etc/redhat-release` | `cat /etc/oracle-release` | `/etc/os-release`, `/etc/debian_version` | `/etc/os-release`, `/etc/SuSE-release` | `oslevel`, `uname -v`, `/etc/os-release` |
| **System Files** | User/Group Info | `/etc/passwd`, `/etc/group` | `/etc/passwd`, `/etc/group` | `/etc/passwd`, `/etc/group` | `/etc/passwd`, `/etc/group` | `/etc/passwd`, `/etc/group` |
| | Shadow/Security | `/etc/shadow`, `/etc/sudoers`, `/etc/sudoers.d/` | `/etc/shadow`, `/etc/sudoers`, `/etc/sudoers.d/` | `/etc/shadow`, `/etc/sudoers`, `/etc/sudoers.d/` | `/etc/shadow`, `/etc/sudoers` | `/etc/security/passwd`, `/etc/security/user`, `/etc/sudoers` |
| | Resource Limits | `/etc/security/limits.conf`, `/etc/security/limits.d/` | `/etc/security/limits.conf`, `/etc/security/limits.d/` | `/etc/security/limits.conf`, `/etc/security/limits.d/` | `/etc/security/limits.conf`, `/etc/security/limits.d/` | `/etc/security/limits` |
| | PAM/Auth Config | `/etc/pam.d/*`, `/etc/login.defs` | `/etc/pam.d/*`, `/etc/login.defs` | `/etc/pam.d/*`, `/etc/login.defs` | `/etc/pam.d/common-*`, `/etc/login.defs` | `/etc/pam.conf`, `/etc/security/login.cfg` |
| | Network Config | `/etc/hosts`, `/etc/resolv.conf` | `/etc/hosts`, `/etc/resolv.conf` | `/etc/hosts`, `/etc/resolv.conf` | `/etc/hosts`, `/etc/resolv.conf` | `/etc/hosts`, `/etc/netsvc.conf` |
| | Audit Config | `/etc/audit/auditd.conf`, `/etc/audit/rules.d/` | `/etc/audit/auditd.conf`, `/etc/audit/rules.d/` | `/etc/audit/auditd.conf` | `/etc/audit/auditd.conf`, `/etc/audit/rules.d/` | `/etc/security/audit/config` |
| **User & Auth** | Password Status | `passwd -S -a` | `passwd -S -a` | `passwd -S <user>` | `passwd -S <user>` | `passwd -S <user>` (implied) |
| | Login Information | `lslogins` | `lslogins` | `getent passwd` | `getent passwd` | `lsgroup`, `who` |
| | Currently Logged In | `w` | `w` | `w` | `w` | `who` |
| | User Home Dir Stats | Loop `/etc/passwd` + `stat` | Loop `/etc/passwd` + `stat` | Loop `/etc/passwd` + `stat` | Loop `/etc/passwd` + `stat` | Loop `/etc/passwd` + `stat` |
| **Logs** | Log File Hierarchy | `ls -lR /var/log` | `ls -lR /var/log` | `ls -lR /var/log` | `ls -lR /var/log` | `ls -lR /var/log` |
| **Network** | Ping Check | `ping -c 4 <host>` | `ping -c 4 <host>` | `ping -c 4 <host>` | `ping -c 4 <host>` | `ping <host> -c 4` |
| | Network Ports | `netstat -tuln` OR `ss -tuln` | `netstat -tuln` OR `ss -tuln` | `ss -tuln` | `ss -tuln` | `netstat -an` |
| **Software** | Installed Pkgs | `rpm -qai` | `rpm -qai` | `dpkg -l`, `apt list --installed` | `zypper info --installed-only` | `lslpp -L` |
| **Processes** | Running Processes | `ps -ef` | `ps -ef` | `ps -ef` | `ps -ef` | `ps -ef` |
| | System Services | `systemctl list-units` | `systemctl list-units` | `systemctl list-units` | `systemctl list-units` | `lsrc -all` |
| **Time** | NTP Synchronization | `chronyc tracking` OR `ntpq -p` | `chronyc tracking` OR `ntpq -p` | `timedatectl`, `ntpq -p` | `chronyc tracking` OR `ntpq -p` | `ntpq -p`, `ntpdate -d` |
| **Scheduling** | System Cron Jobs | `/etc/crontab`, `/etc/cron.d/*` | `/etc/crontab`, `/etc/cron.d/*` | `/etc/crontab`, `/etc/cron.d/*` | `/etc/crontab`, `/etc/cron.d/*` | `/var/adm/cron/*` |
| | User Cron Jobs | `crontab -u <user> -l` | `crontab -u <user> -l` | `crontab -u <user> -l` | `crontab -u <user> -l` | `crontab -l -u <user>` |
| **Integrity** | File Hashes | `sha256sum` | `sha256sum` | `sha256sum`, `shasum`, `md5sum` | `sha256sum`, `md5sum` | `sha256sum`, `shasum`, `digest`, `md5sum` |

## Notes for Porting
- **Package Manager**: Replace `rpm -qai` with `dpkg -l` (Debian/Ubuntu) or `pkg info` (FreeBSD/Solaris) as needed.
- **Service Manager**: If `systemctl` is not available (e.g., older systems, BSD), use `service --status-all` or `chkconfig`.
- **Network Tools**: `netstat` might be deprecated; prefer `ss` on newer Linux systems.
- **Time Sync**: Check for `chronyd`, `ntpd`, or `systemd-timesyncd`.
