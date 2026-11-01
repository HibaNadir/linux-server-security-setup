# Linux Server Hardening – Red Hat Enterprise Linux 9

![Linux](https://img.shields.io/badge/Linux-RHEL%209-red?logo=redhat)
![Security](https://img.shields.io/badge/Focus-Cybersecurity-blue)
![VMware](https://img.shields.io/badge/Virtualization-VMware-green)
![Status](https://img.shields.io/badge/Status-Completed-success)

## Project Overview

This project focuses on securing and hardening a Red Hat Enterprise Linux 9 environment running on VMware Workstation.

The objective was to improve the system's security posture by auditing configurations, strengthening access controls, securing SSH, managing firewall rules, reviewing SELinux policies, reducing unnecessary services, and applying security updates.

The project was conducted in a controlled virtual lab environment for educational purposes.

## Environment & Technologies

| Component | Technology |
|---|---|
| Operating System | Red Hat Enterprise Linux 9 |
| Virtualization | VMware Workstation |
| Firewall | firewalld |
| Access Control | SELinux |
| Remote Access | OpenSSH |
| Package Management | DNF |
| Version Control | Git & GitHub |
| Documentation | Markdown |

## Security Measures Implemented

### 1. Initial Security Audit
- Identified the operating system and system configuration.
- Checked the status of essential security services.
- Reviewed the initial firewall and SELinux configuration.
- Created a protected initial system backup.

### 2. User & Privilege Management
- Reviewed user accounts and administrative privileges.
- Configured the administrative user with `sudo` access through the `wheel` group.
- Validated sudoers configuration.
- Applied the principle of least privilege.

### 3. SSH Hardening
- Disabled direct root login over SSH.
- Reduced maximum authentication attempts to 3.
- Disabled X11 forwarding.
- Kept password authentication enabled because SSH key access had not yet been configured and tested.

### 4. Firewall Hardening
- Audited the active firewalld zone.
- Removed the unnecessary Cockpit service from the public zone.
- Verified permanent and runtime firewall configurations.
- Retained the required SSH service.

### 5. SELinux Verification
- Confirmed SELinux is enabled and running in Enforcing mode.
- Reviewed custom SELinux booleans.
- Checked SSH security contexts.
- Reviewed recent SELinux AVC audit events.

### 6. Service & Permission Hardening
- Reviewed sensitive system file permissions.
- Disabled unnecessary services:
  - Avahi
  - CUPS
  - Bluetooth
  - ModemManager
  - libstoragemgmt
- Verified that essential services remained operational.
- Checked listening network ports.

### 7. Security Updates & Final Audit
- Reviewed available security advisories.
- Applied available security updates using DNF.
- Rebooted the system to activate the updated kernel.
- Verified the firewall, SELinux and system service status.
- Confirmed that no failed systemd units remained during the final audit.

### 8. Automated Security Audit

Developed a Bash script to automate security verification on the RHEL 9 server.

**Security checks performed:**
- SELinux enforcement status.
- Firewall service status.
- SSH security configuration.
- Essential system services status.
- Failed systemd units.

**Automation features:**
- Automatic security check counting.
- PASS/WARNING overall audit result.
- Timestamped audit logs.
- Automatic HTML security report generation.
- Dynamic status indicators in the HTML report.

**Execution:**

```bash
bash scripts/security-audit.sh
```

**Generated files:**
- `logs/`: Timestamped audit logs.
- `reports/`: HTML security audit reports.

Generated logs and HTML reports are excluded from Git using `.gitignore` to avoid publishing machine-specific audit information.

## Project Screenshots

The following screenshots provide evidence of the implemented security configurations.

### 1. Initial System Audit
![Initial System Audit](screenshots/01-system-audit.png)

### 2. SSH Hardening
![SSH Hardening](screenshots/02-ssh-hardening.png)

### 3. Firewall Configuration
![Firewall Configuration](screenshots/03-firewall.png)

### 4. SELinux Enforcement
![SELinux Enforcement](screenshots/04-selinux.png)

### 5. Final Security Audit
![Final Security Audit](screenshots/05-final-audit.png)

## Project Structure
```
linux-server-security-setup/
│
├── configs/
│
├── docs/
│   ├── firewall-hardening.md
│   ├── selinux-hardening.md
│   ├── service-hardening.md
│   ├── ssh-hardening.md
│   ├── update-and-final-audit.md
│   └── user-management.md
│
├── logs/                       # Generated audit logs (ignored by Git)
├── reports/                    # Generated HTML reports (ignored by Git)
│
├── scripts/
│   └── security-audit.sh
│
├── screenshots/
│   ├── 01-system-audit.png
│   ├── 02-ssh-hardening.png
│   ├── 03-firewall.png
│   ├── 04-selinux.png
│   └── 05-final-audit.png
│
├── .gitignore
├── PROJECT_REPORT.md
└── README.md
```
## Skills Demonstrated

- Linux System Administration
- Linux Server Hardening
- SSH Security Configuration
- Firewall Management
- SELinux Security
- User & Privilege Management
- System Auditing
- Security Patch Management
- Git & GitHub
- Technical Documentation

## Future Improvements

- Extend the automated security audit with additional checks for open ports, system updates, and file permissions.
- Configure and test SSH key-based authentication.
- Disable SSH password authentication after successfully validating key-based access.
- Implement centralized log monitoring and analysis.
- Explore intrusion detection and security monitoring tools to improve threat visibility.

## Disclaimer

This project was developed in a virtual lab environment for educational purposes.

Security configurations should always be tested and validated before deployment in production environments.

---

**Author:** Hiba Nadir  
**Focus:** Cybersecurity & Linux System Administration  
**Platform:** Red Hat Enterprise Linux 9
