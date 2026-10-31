#!/bin/bash

# Linux Server Hardening
# Automated Security Audit - RHEL 9

LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/security-audit-$(date +%Y%m%d-%H%M%S).log"

# HTML report configuration
REPORT_DIR="$(dirname "$0")/../reports"
mkdir -p "$REPORT_DIR"

REPORT_FILE="$REPORT_DIR/security-report-$(date +%Y%m%d-%H%M%S).html"

# Display results and save them in the log file
exec > >(tee "$LOG_FILE") 2>&1

# Audit counters
PASS_COUNT=0
WARNING_COUNT=0

# Report data
AUDIT_DATE=$(date)
SELINUX_STATUS="Unknown"
FIREWALL_STATUS="Unknown"
SSH_STATUS="Unknown"
FAILED_UNITS=0

echo "=========================================="
echo "       LINUX SECURITY AUDIT"
echo "       Red Hat Enterprise Linux 9"
echo "=========================================="

echo ""
echo "Audit date: $(date)"

echo ""
echo "[1] OPERATING SYSTEM"

OS_INFO=$(cat /etc/redhat-release)
echo "$OS_INFO"

echo ""
echo "[2] SELINUX STATUS"

SELINUX_STATUS=$(getenforce)

if [ "$SELINUX_STATUS" = "Enforcing" ]; then
    echo "[OK] SELinux is Enforcing"
    ((PASS_COUNT++))
else
    echo "[WARNING] SELinux is not Enforcing"
    ((WARNING_COUNT++))
fi
echo ""
echo "[3] FIREWALL STATUS"

if sudo firewall-cmd --state | grep -q "running"; then
    FIREWALL_STATUS="Running"
    echo "[OK] Firewall is running"
    ((PASS_COUNT++))
else
    FIREWALL_STATUS="Stopped"
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
    SSH_STATUS="Hardened"
    echo "[OK] SSH hardening checks passed"
    ((PASS_COUNT++))
else
    SSH_STATUS="Needs review"
    echo "[WARNING] SSH hardening checks need review"
    ((WARNING_COUNT++))
fi

echo ""
echo "[5] ESSENTIAL SERVICES"

SERVICE_ROWS=""

for service in sshd firewalld auditd NetworkManager; do
    if systemctl is-active --quiet "$service"; then
        echo "[OK] $service is active"
        SERVICE_ROWS+="<tr><td>$service</td><td class='success'>Active</td></tr>"
        ((PASS_COUNT++))
    else
        echo "[WARNING] $service is not active"
        SERVICE_ROWS+="<tr><td>$service</td><td class='warning'>Inactive</td></tr>"
        ((WARNING_COUNT++))
    fi
done

echo ""
echo "[6] FAILED SYSTEMD UNITS"

FAILED_UNITS=$(systemctl --failed --no-legend | wc -l)

if [ "$FAILED_UNITS" -eq 0 ]; then
    echo "[OK] No failed systemd units"
    ((PASS_COUNT++))
else
    echo "[WARNING] $FAILED_UNITS failed systemd unit(s)"
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
    AUDIT_RESULT="PASS"
    echo "Overall result: PASS"
else
    AUDIT_RESULT="WARNING"
    echo "Overall result: WARNING"
fi
# Generate HTML security report
cat > "$REPORT_FILE" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RHEL 9 Security Audit Report</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f1f5f9;
            color: #1e293b;
            margin: 0;
            padding: 30px;
        }

        .container {
            max-width: 900px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
        }

        h1 {
            color: #0f172a;
        }

        .date {
            color: #64748b;
        }

        .cards {
            display: flex;
            gap: 15px;
            margin: 25px 0;
        }

        .card {
            flex: 1;
            padding: 20px;
            background: #f8fafc;
            border-radius: 8px;
            text-align: center;
        }

        .success {
            color: #15803d;
            font-weight: bold;
        }

        .warning {
            color: #dc2626;
            font-weight: bold;
        }

        .result {
            padding: 15px;
            border-radius: 8px;
            font-weight: bold;
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th, td {
            padding: 12px;
            border-bottom: 1px solid #e2e8f0;
            text-align: left;
        }

        th {
            background: #f1f5f9;
        }

        footer {
            margin-top: 30px;
            color: #64748b;
            font-size: 13px;
        }
    </style>
</head>

<body>
<div class="container">

    <h1>Linux Server Security Audit</h1>
    <p class="date">Generated: $AUDIT_DATE</p>

    <h2>System Information</h2>
    <p><strong>Operating System:</strong> $OS_INFO</p>

    <div class="cards">
        <div class="card">
            <h2 class="success">$PASS_COUNT</h2>
            <p>Successful Checks</p>
        </div>

        <div class="card">
            <h2 class="warning">$WARNING_COUNT</h2>
            <p>Warnings</p>
        </div>
    </div>

    <h2>Overall Security Result</h2>
    <p class="result">$AUDIT_RESULT</p>

    <h2>Security Configuration</h2>

    <table>
        <tr>
            <th>Security Component</th>
            <th>Status</th>
        </tr>

        <tr>
            <td>SELinux</td>
            <td>$SELINUX_STATUS</td>
        </tr>

        <tr>
            <td>Firewall</td>
            <td>$FIREWALL_STATUS</td>
        </tr>

        <tr>
            <td>SSH Hardening</td>
            <td>$SSH_STATUS</td>
        </tr>

        <tr>
            <td>Failed Systemd Units</td>
            <td>$FAILED_UNITS</td>
        </tr>

        $SERVICE_ROWS

    </table>

    <footer>
        Linux Server Hardening Project - RHEL 9
        <br>
        Automated Security Audit Report
    </footer>

</div>
</body>
</html>
EOF

echo ""
echo "=========================================="
echo "          AUDIT COMPLETED"
echo "=========================================="

echo ""
echo "Log saved to: $LOG_FILE"
