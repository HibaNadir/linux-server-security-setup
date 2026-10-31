
#!/bin/bash

# Linux Server Hardening
# Automated Security Audit - RHEL 9

echo "=========================================="
echo "       LINUX SECURITY AUDIT"
echo "       Red Hat Enterprise Linux 9"
echo "=========================================="

echo ""
echo "[1] OPERATING SYSTEM"
cat /etc/redhat-release

echo ""
echo "[2] SELINUX STATUS"
getenforce

echo ""
echo "[3] FIREWALL STATUS"
sudo firewall-cmd --state

echo ""
echo "[4] SSH SECURITY CONFIGURATION"
sudo sshd -T | grep -E \
'permitrootlogin|maxauthtries|passwordauthentication|pubkeyauthentication|x11forwarding'

echo ""
echo "[5] ESSENTIAL SERVICES"

for service in sshd firewalld auditd NetworkManager; do
    if systemctl is-active --quiet "$service"; then
        echo "[OK] $service is active"
    else
        echo "[WARNING] $service is not active"
    fi
done

echo ""
echo "[6] FAILED SYSTEMD UNITS"
sudo systemctl --failed

echo ""
echo "=========================================="
echo "          AUDIT COMPLETED"
echo "=========================================="
