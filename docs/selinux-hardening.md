
# SELinux Hardening – RHEL 9

## Objective
Verify and maintain SELinux security enforcement on RHEL 9.

## Initial Audit
- SELinux status: enabled
- SELinux mode: Enforcing
- Configuration file: SELINUX=enforcing
- Recent AVC denials: No matches found

## Security Checks
- Reviewed enabled SELinux booleans.
- Identified two customized booleans:
  - virt_sandbox_use_all_caps
  - virt_use_nfs
- Checked SSH directory security context.
- Verified SSH contexts using restorecon in preview mode.

## Validation
- SELinux remains enabled and enforcing.
- No recent AVC denials were found.
- SSH directory context: system_u:object_r:etc_t:s0
- No context corrections were reported by restorecon.

## Security Benefits
- Mandatory Access Control remains enforced.
- SELinux security contexts were verified.
- Existing custom policies were reviewed without unnecessary changes.

## Future Improvements
- Review customized SELinux booleans according to actual service requirements.
- Monitor SELinux audit logs regularly.
- Investigate AVC denials if they occur.
