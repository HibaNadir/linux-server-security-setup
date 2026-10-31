# User and Privilege Management - RHEL 9

## 1. Objective

Improve account security and apply the principle of least privilege.

## 2. User Account Verification

The existing user account `hnadir` was verified.

Command used:

    id hnadir

The account belongs to the `wheel` group.

## 3. Administrative Privileges

The user was added to the `wheel` group:

    sudo usermod -aG wheel hnadir

Sudoers configuration was checked using:

    sudo visudo -c

Result: syntax OK.

## 4. Sudo Access Verification

Administrative access was tested using:

    sudo whoami

Result:

    root

The test confirmed that the user can execute authorized administrative commands through sudo.

## 5. Security Benefits

- Individual user account instead of routine root login.
- Administrative privileges restricted to authorized users.
- Sudo configuration syntax verified.
- Principle of least privilege applied.

## 6. Conclusion

User and privilege management checks were completed successfully on RHEL 9.
