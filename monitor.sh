#!/bin/bash
set -euo pipefail

LOG_DIR="$(dirname "$0")/logs"
LOG_FILE="$LOG_DIR/health-$(date +%F).log"
mkdir -p "$LOG_DIR"

log() {
    local level="$1"
    local msg="$2"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $msg" | tee -a "$LOG_FILE"
}

cpu_level() {
    if (( $(echo "$1 >= 90" | bc -l) )); then echo "CRITICAL"
    elif (( $(echo "$1 >= 70" | bc -l) )); then echo "WARNING"
    else echo "INFO"
    fi
}

mem_level() {
    if (( $(echo "$1 >= 95" | bc -l) )); then echo "CRITICAL"
    elif (( $(echo "$1 >= 80" | bc -l) )); then echo "WARNING"
    else echo "INFO"
    fi
}

disk_level() {
    if (( $(echo "$1 >= 95" | bc -l) )); then echo "CRITICAL"
    elif (( $(echo "$1 >= 85" | bc -l) )); then echo "WARNING"
    else echo "INFO"
    fi
}

CPU_VAL=$(top -bn2 -d0.5 | grep "Cpu" | tail -1 | awk '{printf "%.1f", 100 - $8}')
MEM_VAL=$(free | awk '/Mem:/ {printf "%.1f", $3/$2*100}')
DISC_VAL=$(df / | awk 'NR==2 {gsub("%",""); print $5}')

log "$(cpu_level  "$CPU_VAL")"  "CPU usage: ${CPU_VAL}%"
log "$(mem_level  "$MEM_VAL")"  "RAM usage: ${MEM_VAL}%"
log "$(disk_level "$DISC_VAL")" "Disk usage: ${DISC_VAL}%"

log "INFO" "Top processes by CPU:"
ps aux | awk 'NR>1 {printf "%.1f%% %s\n", $3, $11}' | sort -rn | head -5 | while read -r line; do
    log "INFO" "  $line"
done
