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
    SELINUX_CLASS="success"
    echo "[OK] SELinux is Enforcing"
    ((PASS_COUNT++))
else
    SELINUX_CLASS="warning"
    echo "[WARNING] SELinux is not Enforcing"
    ((WARNING_COUNT++))
fi

echo ""
echo "[3] FIREWALL STATUS"

if sudo firewall-cmd --state | grep -q "running"; then
    FIREWALL_STATUS="Running"
    FIREWALL_CLASS="success"
    echo "[OK] Firewall is running"
    ((PASS_COUNT++))
else
    FIREWALL_STATUS="Stopped"
    FIREWALL_CLASS="warning"
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
    SSH_CLASS="success"
    echo "[OK] SSH hardening checks passed"
    ((PASS_COUNT++))
else
    SSH_STATUS="Needs review"
    SSH_CLASS="warning"
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
    RESULT_CLASS="success"
    echo "Overall result: PASS"
else
    AUDIT_RESULT="WARNING"
    RESULT_CLASS="warning"
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
	        * {
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: #0f172a;
            color: #e2e8f0;
            margin: 0;
            padding: 40px 20px;
        }

        .container {
            max-width: 1000px;
            margin: auto;
            background: #1e293b;
            padding: 35px;
            border: 1px solid #334155;
            border-radius: 16px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
        }

        h1 {
            color: #38bdf8;
            font-size: 30px;
            margin-bottom: 8px;
        }

        h2 {
            color: #f8fafc;
            margin-top: 30px;
        }

        .date {
            color: #94a3b8;
            font-size: 14px;
        }

        .cards {
            display: flex;
            gap: 20px;
            margin: 30px 0;
        }

        .card {
            flex: 1;
            padding: 22px;
            background: #0f172a;
            border: 1px solid #334155;
            border-radius: 12px;
            text-align: center;
        }

        .card h2 {
            font-size: 36px;
            margin: 0;
        }

        .card p {
            color: #cbd5e1;
            margin-bottom: 0;
        }

        .success {
            color: #4ade80;
            font-weight: bold;
        }

        .warning {
            color: #f87171;
            font-weight: bold;
        }

        .result {
            padding: 16px;
            border-radius: 10px;
            text-align: center;
            font-size: 20px;
            font-weight: bold;
            background: #0f172a;
            border: 1px solid currentColor;
        }

        .system-info {
            background: #0f172a;
            padding: 18px;
            border-radius: 10px;
            border-left: 4px solid #38bdf8;
            color: #cbd5e1;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 18px;
            overflow: hidden;
            border-radius: 10px;
        }

        th, td {
            padding: 15px;
            border-bottom: 1px solid #334155;
            text-align: left;
        }

        th {
            background: #0f172a;
            color: #38bdf8;
        }

        td {
            color: #e2e8f0;
        }

        tr:hover {
            background: #263449;
        }

        footer {
            margin-top: 35px;
            padding-top: 20px;
            border-top: 1px solid #334155;
            color: #94a3b8;
            font-size: 13px;
            text-align: center;
        }

        @media (max-width: 600px) {
            body {
                padding: 15px;
            }

            .container {
                padding: 20px;
            }

            .cards {
                flex-direction: column;
            }

            h1 {
                font-size: 23px;
            }
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
    <p class="result $RESULT_CLASS">$AUDIT_RESULT</p>

    <h2>Security Configuration</h2>

    <table>
        <tr>
            <th>Security Component</th>
            <th>Status</th>
        </tr>

        <tr>
            <td>SELinux</td>
            <td class="$SELINUX_CLASS">$SELINUX_STATUS</td>
        </tr>

        <tr>
            <td>Firewall</td>
            <td class="$FIREWALL_CLASS">$FIREWALL_STATUS</td>
        </tr>

        <tr>
            <td>SSH Hardening</td>
            <td class="$SSH_CLASS">$SSH_STATUS</td>
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
