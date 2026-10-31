# Security Updates and Final Audit - RHEL 9

## 1. Objective

Install available security updates and perform a final verification of the Linux server hardening configuration.

## 2. Subscription Status

- Red Hat system registered.
- Simple Content Access enabled.
- Access to repositories confirmed.

## 3. Security Updates

Preview command:

    sudo dnf upgrade --security --assumeno

The preview showed:
- 36 packages to upgrade.
- 6 packages to install.
- 324 MB of downloads.

Installation command:

    sudo dnf upgrade --security

Result: Transaction completed successfully.

A subsequent check returned "Rien à faire !", meaning no additional security updates were available at that check.

## 4. Kernel Update

New kernel installed:

    5.14.0-687.61.1.el9_8.x86_64

The system was rebooted to activate the new kernel.

## 5. Final Security Audit

| Check | Result | Status |
|---|---|---|
| Running kernel | 5.14.0-687.61.1.el9_8.x86_64 | Passed |
| SELinux | Enforcing | Passed |
| Firewalld | Running | Passed |
| Failed systemd units | 0 | Passed |
| Remaining listed security advisories | No output | Passed |

## 6. Conclusion

Security updates were successfully installed.
The system was rebooted and the new kernel was verified.

SELinux remains in enforcing mode, the firewall is running, and no failed systemd units were reported during the final audit.

The security advisory query returned no entries at the time of verification.

The RHEL 9 hardening lab was completed with the checks documented above.
