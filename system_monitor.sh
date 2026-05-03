#!/bin/bash

# ==============================
# System Monitor Script
# Author: Rudra
# Description: Monitors system health
# ==============================

echo "=============================="
echo " SYSTEM HEALTH MONITOR"
echo " $(date)"
echo "=============================="

echo "HOSTNAME : $(hostname)"
echo "OS       : $(sw_vers -productName) $(sw_vers -productVersion)"
echo "KERNEL   : $(uname -r)"
echo "UPTIME   : $(uptime | awk '{print $3, $4}' | sed 's/,//')"
echo ""

echo "--- CPU USAGE ---"
top -l 1 | grep "CPU usage"
echo ""

echo "--- MEMORY USAGE ---"

vm_stat | awk '
/Pages free/ {free=$3}
/Pages active/ {active=$3}
/Pages inactive/ {inactive=$3}
END {
    total=(free+active+inactive)*4096/1048576
    used=(active+inactive)*4096/1048576
    printf "Used: %.2f MB / Total: %.2f MB\n", used, total
}'
echo ""

echo "--- DISK USAGE ---"
df -h | grep "/dev/disk"
echo ""

echo "--- TOP PROCESSES ---"
ps aux | sort -nrk 3 | head -5
echo ""

echo "--- USERS ---"
who
echo ""

echo "--- ALERTS ---"

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$DISK_USAGE" -gt 80 ]; then
    echo "Disk usage high: ${DISK_USAGE}%"
else
    echo "Disk usage normal: ${DISK_USAGE}%"
fi

echo ""
