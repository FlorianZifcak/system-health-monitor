#!/bin/bash
set -euo pipefail

LOG_DIR="$(dirname "$0")/logs"
LOG_FILE="$LOG_DIR/health-$(date +%F).log"
N=${1:-20}

tail -n "$N" "$LOG_FILE"

WARN_COUNT=$(echo "$LOG_FILE" | grep -c "WARNING" || true)
CRIT_COUNT=$(echo "$LOG_FILE" | grep -c "CRITICAL" || true)

echo "[$(date +%F)] WARNING count: $WARN_COUNT"
echo "[$(date +%F)] CRITICAL count: $CRIT_COUNT"

