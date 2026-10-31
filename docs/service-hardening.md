
# Service Hardening – RHEL 9

## Objective
Reduce the attack surface by disabling unnecessary system services.

## Initial Audit
Reviewed running services, enabled services and listening network ports.

## Services Disabled
- avahi-daemon
- cups
- bluetooth
- ModemManager
- libstoragemgmt

## Services Preserved
- firewalld
- sshd
- auditd
- NetworkManager
- chronyd
- vmtoolsd

## Validation
- Confirmed the five services are disabled.
- Confirmed essential security and network services remain active.
- Confirmed SSH remains available on port 22.
- Confirmed Avahi port 5353 and CUPS port 631 are no longer listening.

## Security Benefits
- Reduced unnecessary running services.
- Reduced network exposure.
- Improved server configuration for a security laboratory.

## Future Improvements
- Review systemd socket activation.
- Regularly audit running services.
- Monitor listening network ports.
