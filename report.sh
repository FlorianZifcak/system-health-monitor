#!/bin/bash
set -euo pipefail

LOG_DIR="$(dirname "$0")/logs"
LOG_FILE="$LOG_DIR/health-$(date +%F).log"
N=${1:-20}

tail -n "$N" "$LOG_FILE"

WARN_COUNT=$(grep -c "WARNING" "$LOG_FILE" || true)
CRIT_COUNT=$(grep -c "CRITICAL" "$LOG_FILE" || true)

echo "[$(date +%F)] WARNING count: $WARN_COUNT"
echo "[$(date +%F)] CRITICAL count: $CRIT_COUNT"

if grep -q "CRITICAL.*CPU" "$LOG_FILE"; then
    CPU_LEVEL="CRITICAL"
elif grep -q "WARNING.*CPU" "$LOG_FILE"; then
    CPU_LEVEL="WARNING"
else
    CPU_LEVEL="INFO"
fi

if grep -q "CRITICAL.*RAM" "$LOG_FILE"; then
    RAM_LEVEL="CRITICAL"
elif grep -q "WARNING.*RAM" "$LOG_FILE"; then
    RAM_LEVEL="WARNING"
else
    RAM_LEVEL="INFO"
fi

if grep -q "CRITICAL.*Disk" "$LOG_FILE"; then
    DISK_LEVEL="CRITICAL"
elif grep -q "WARNING.*Disk" "$LOG_FILE"; then
    DISK_LEVEL="WARNING"
else
    DISK_LEVEL="INFO"
fi

WORST=$(printf "3 CRITICAL\n2 WARNING\n1 INFO\n" | \
    grep -w "$CPU_LEVEL\|$RAM_LEVEL\|$DISK_LEVEL" | \
    sort -rn | head -1 | awk '{print $2}')

echo "Najhoršia metrika: $WORST"
