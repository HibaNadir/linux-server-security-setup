#!/bin/bash

# Linux Server Hardening
# Automated Security Audit - RHEL 9

LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/security-audit-$(date +%Y%m%d-%H%M%S).log"

# Display results and save them in the log file
exec > >(tee "$LOG_FILE") 2>&1

# Audit counters
PASS_COUNT=0
WARNING_COUNT=0

echo "=========================================="
echo "       LINUX SECURITY AUDIT"
echo "       Red Hat Enterprise Linux 9"
echo "=========================================="

echo ""
echo "Audit date: $(date)"

echo ""
echo "[1] OPERATING SYSTEM"
cat /etc/redhat-release

echo ""
echo "[2] SELINUX STATUS"

if [ "$(getenforce)" = "Enforcing" ]; then
    echo "[OK] SELinux is Enforcing"
    ((PASS_COUNT++))
else
    echo "[WARNING] SELinux is not Enforcing"
    ((WARNING_COUNT++))
fi

echo ""
echo "[3] FIREWALL STATUS"

if sudo firewall-cmd --state | grep -q "running"; then
    echo "[OK] Firewall is running"
    ((PASS_COUNT++))
else
    echo "[WARNING] Firewall is not running"
    ((WARNING_COUNT++))
fi
echo ""
echo "[4] SSH SECURITY CONFIGURATION"

SSH_CONFIG=$(sudo sshd -T)

echo "$SSH_CONFIG" | grep -E \
'permitrootlogin|maxauthtries|passwordauthentication|pubkeyauthentication|x11forwarding'

if echo "$SSH_CONFIG" | grep -q "^permitrootlogin no$" &&
   echo "$SSH_CONFIG" | grep -q "^maxauthtries 3$" &&
   echo "$SSH_CONFIG" | grep -q "^x11forwarding no$"; then
    echo "[OK] SSH hardening checks passed"
    ((PASS_COUNT++))
else
    echo "[WARNING] SSH hardening checks need review"
    ((WARNING_COUNT++))
fi

echo ""
echo "[5] ESSENTIAL SERVICES"

for service in sshd firewalld auditd NetworkManager; do
    if systemctl is-active --quiet "$service"; then
        echo "[OK] $service is active"
        ((PASS_COUNT++))
    else
        echo "[WARNING] $service is not active"
        ((WARNING_COUNT++))
    fi
done

echo ""
echo "[6] FAILED SYSTEMD UNITS"

FAILED_COUNT=$(systemctl --failed --no-legend | wc -l)

if [ "$FAILED_COUNT" -eq 0 ]; then
    echo "[OK] No failed systemd units"
    ((PASS_COUNT++))
else
    echo "[WARNING] $FAILED_COUNT failed systemd unit(s)"
    systemctl --failed
    ((WARNING_COUNT++))
fi

echo ""
echo "=========================================="
echo "          SECURITY SUMMARY"
echo "=========================================="

echo "Successful checks: $PASS_COUNT"
echo "Warnings: $WARNING_COUNT"

if [ "$WARNING_COUNT" -eq 0 ]; then
    echo "Overall result: PASS"
else
    echo "Overall result: WARNING"
fi

echo ""
echo "=========================================="
echo "          AUDIT COMPLETED"
echo "=========================================="

echo ""
echo "Log saved to: $LOG_FILE"
