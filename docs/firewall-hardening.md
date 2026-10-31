# Firewall Hardening – RHEL 9

## Objective
Reduce unnecessary network exposure by reviewing and cleaning firewall rules using firewalld.

## Initial Audit
- firewalld service: active and enabled
- Default zone: public
- Network interface: ens160
- Active zone: public
- SSH service: allowed
- Cockpit service: allowed but not used
- DHCPv6 client: allowed

## Security Changes
- Removed the unnecessary Cockpit service from the public zone.
- Kept SSH access enabled for remote administration.
- Kept DHCPv6 client service allowed.
- Applied the changes using firewall-cmd --reload.

## Validation
- Verified active firewall services.
- Verified permanent firewall services.
- Confirmed Cockpit is disabled and inactive.
- Confirmed SSH service remains active.

## Security Benefits
- Reduced unnecessary network exposure.
- Removed an unused firewall service.
- Preserved SSH administration access.
- Maintained a documented firewall configuration.

## Future Improvements
- Review whether DHCPv6 is required.
- Review other network services and listening ports.
- Perform authorized connectivity tests.
