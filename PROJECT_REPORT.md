# Technical Project Report
## Linux Server Hardening – Red Hat Enterprise Linux 9

**Author:** Hiba Nadir  
**Project Category:** Cybersecurity / Linux System Administration  
**Operating System:** Red Hat Enterprise Linux 9  
**Virtualization Platform:** VMware Workstation  
**Project Status:** Completed  

---

## 1. Executive Summary

This project involved performing a security hardening assessment and implementing security improvements on a Red Hat Enterprise Linux 9 virtual machine.

The main objective was to reduce the system's attack surface, strengthen access controls, improve network security, review mandatory access control policies, and ensure that security updates were applied.

The work was performed in a controlled VMware virtual environment.

The project covered seven main areas:

- Initial security assessment
- User and privilege management
- SSH configuration hardening
- Firewall configuration
- SELinux verification
- Service and file permission management
- Security updates and final system audit

## 2. Laboratory Environment

| Component | Configuration |
|---|---|
| Operating System | Red Hat Enterprise Linux 9 |
| Virtualization | VMware Workstation |
| Network Interface | ens160 |
| Firewall | firewalld |
| Security Framework | SELinux |
| Remote Access | OpenSSH |
| Package Manager | DNF |
| Version Control | Git and GitHub |

All security changes were tested inside a virtual machine.

## 3. Initial Security Assessment

The first phase consisted of examining the system's initial security configuration.

The following components were reviewed:

- Operating system version
- SELinux enforcement status
- Firewall service status
- SSH service status
- User accounts and administrative privileges
- Active system services
- Listening network ports
- Sensitive file permissions

An initial system backup was also created before applying configuration changes.

The assessment established the baseline used to guide subsequent hardening operations.

## 4. Security Improvements Implemented

### 4.1 User and Privilege Management

**Objective:** Restrict administrative privileges and apply the principle of least privilege.

Actions performed:

- Reviewed the administrative user account.
- Added the `hnadir` account to the `wheel` group.
- Verified sudo access.
- Validated the sudoers configuration using `visudo -c`.

**Result:** Administrative operations can be performed through controlled sudo privileges instead of relying on direct root access.

### 4.2 SSH Configuration Hardening

**Objective:** Reduce risks associated with remote access.

The following SSH parameters were configured:

| Parameter | Final Value |
|---|---|
| PermitRootLogin | no |
| MaxAuthTries | 3 |
| PubkeyAuthentication | yes |
| PasswordAuthentication | yes |
| X11Forwarding | no |

Actions performed:

- Disabled direct root login through SSH.
- Reduced authentication attempts to three.
- Disabled X11 forwarding.
- Kept password authentication enabled because SSH key-based access had not yet been configured and tested.
- Validated the SSH configuration before reloading the service.

**Result:** The SSH configuration was successfully hardened while preserving the existing authentication method.

### 4.3 Firewall Hardening

**Objective:** Reduce unnecessary network exposure.

Actions performed:

- Audited the active firewalld zone.
- Reviewed allowed services.
- Removed the unnecessary Cockpit service from the public zone.
- Verified runtime and permanent firewall configurations.
- Retained the SSH service required for remote administration.

**Result:** The public firewall zone was simplified by removing an unnecessary service.

### 4.4 SELinux Verification

**Objective:** Ensure mandatory access control remains enabled.

Actions performed:

- Verified that SELinux was enabled.
- Confirmed the Enforcing mode.
- Reviewed customized SELinux booleans.
- Checked SSH security contexts.
- Reviewed recent AVC audit events.

**Result:** SELinux remained in Enforcing mode throughout the project. No recent AVC denials were found during the reviewed audit query.

### 4.5 Service and File Permission Hardening

**Objective:** Reduce unnecessary background services and review access to sensitive system files.

The following services were disabled:

- Avahi
- CUPS
- Bluetooth
- ModemManager
- libstoragemgmt

Additional operations:

- Reviewed permissions on `/etc/passwd`.
- Reviewed permissions on `/etc/shadow`.
- Reviewed permissions on `/etc/group`.
- Reviewed permissions on `/etc/sudoers`.
- Checked listening network ports.
- Verified that essential services remained operational.

**Result:** Unnecessary services were disabled, and the reviewed sensitive file permissions matched the expected values.

### 4.6 Security Updates

**Objective:** Apply available security updates.

Actions performed:

- Checked available package updates.
- Reviewed security advisories.
- Previewed the security upgrade transaction.
- Applied available security updates using DNF.
- Rebooted the virtual machine to activate the updated kernel.

**Result:** Security updates were successfully installed, including a kernel update.

## 5. Final Security Verification

After completing the hardening operations, a final verification was performed.

| Security Component | Final Observation |
|---|---|
| SELinux | Enforcing |
| Firewall | Running |
| SSH | Active |
| Kernel | Updated kernel running |
| Systemd | No failed units reported |
| Security advisories | No entries returned by the final security advisory query |

These results demonstrate that the main hardening operations were applied and verified successfully at the time of the final audit.

## 6. Project Limitations

This project was conducted in a virtual laboratory and does not represent a complete production security assessment.

The following limitations remain:

- SSH password authentication is still enabled.
- SSH key-based authentication has not yet been configured and tested.
- No centralized log monitoring solution has been implemented.
- No automated vulnerability scanning platform has been deployed.
- No intrusion detection system has been integrated into this RHEL 9 environment.

These limitations provide opportunities for future improvements.

## 7. Future Improvements

Potential next steps include:

1. Configure and validate SSH key-based authentication.
2. Disable SSH password authentication after successful key testing.
3. Develop automated Linux security audit scripts.
4. Implement centralized log monitoring.
5. Explore intrusion detection and security monitoring.
6. Schedule regular security update checks.
7. Perform periodic configuration reviews.

## 8. Conclusion

This project provided practical experience in Linux system administration and defensive cybersecurity.

It demonstrated the importance of access control, secure remote administration, firewall management, mandatory access control, service minimization, and security patch management.

The laboratory also reinforced the importance of validating configuration changes and documenting technical operations.

**Project Repository:**  
https://github.com/HibaNadir/linux-server-security-setup

**Author:** Hiba Nadir  
**Focus:** Cybersecurity and Linux System Administration
