# SSH Hardening – RHEL 9

## 1. Objective

Improve SSH server security by reducing unnecessary access privileges and limiting authentication attempts.

## 2. Initial Audit

The initial SSH configuration showed:

- SSH service active and enabled.
- SSH listening on port 22.
- Direct root password login prohibited.
- Password authentication enabled.
- Public key authentication enabled.
- Maximum authentication attempts: 6.
- X11 forwarding enabled.

## 3. Security Changes

A dedicated configuration file was created:

`/etc/ssh/sshd_config.d/00-hardening.conf`

The following settings were applied:

| Parameter | New value | Purpose |
|---|---|---|
| PermitRootLogin | no | Prevent direct root SSH login |
| MaxAuthTries | 3 | Limit authentication attempts |
| X11Forwarding | no | Disable unnecessary X11 forwarding |
| PasswordAuthentication | yes | Retain password access temporarily |
| PubkeyAuthentication | yes | Allow public key authentication |

## 4. Validation

Commands used:

- `sshd -t` – Validate SSH configuration syntax.
- `sshd -T` – Display effective SSH settings.
- `systemctl reload sshd` – Apply configuration changes.
- `systemctl status sshd` – Verify service status.

## 5. Results

The configuration was validated successfully and the SSH service reloaded without errors.

The service remained active after applying the changes.

## 6. Future Improvements

- Configure and test SSH key-based authentication.
- Consider disabling password authentication after successful key testing.
- Perform an authorized remote connection test.
