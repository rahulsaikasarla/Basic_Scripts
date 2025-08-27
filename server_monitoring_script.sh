#!/bin/bash

# Set usage threshold for memory, disk, and CPU
THRESHOLD=80

# Alert email details
TO_EMAIL="rahool.kasarla1212@gmail.com"
HOST=$(hostname)

while true; do
    
    
    # Memory Utilization
    
    MEM_USED=$(free | awk '/Mem/ { printf("%.0f", $3/$2 * 100) }')
    if [ "$MEM_USED" -ge "$THRESHOLD" ]; then
        SUBJECT="dev-server-memory-utilization"
        BODY="Warning: Memory utilization exceeded ${THRESHOLD}% on $HOST - Current usage: $MEM_USED%"
        echo "$BODY" | mail -s "$SUBJECT" "$TO_EMAIL"
        
        # Wait until it drops
        while [ "$MEM_USED" -ge "$THRESHOLD" ]; do
            sleep 60
            MEM_USED=$(free | awk '/Mem/ { printf("%.0f", $3/$2 * 100) }')
        done
    fi

    
    # Disk Utilization (root partition /)
    
    DISK_USED=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ "$DISK_USED" -ge "$THRESHOLD" ]; then
        SUBJECT="dev-server-disk-utilization"
        BODY="Warning: Disk utilization exceeded ${THRESHOLD}% on $HOST - Current usage: $DISK_USED%"
        echo "$BODY" | mail -s "$SUBJECT" "$TO_EMAIL"
        
        # Wait until it drops
        while [ "$DISK_USED" -ge "$THRESHOLD" ]; do
            sleep 60
            DISK_USED=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
        done
    fi

    
    # CPU Utilization (avg %)
    
    if command -v mpstat >/dev/null 2>&1; then
        CPU_USED=$(mpstat 1 1 | awk '/Average:/ {print 100 - $12}')
    else
        CPU_USED=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    fi
    CPU_USED=$(printf "%.0f" "$CPU_USED")

    if [ "$CPU_USED" -ge "$THRESHOLD" ]; then
        SUBJECT="dev-server-cpu-utilization"
        BODY="Warning: CPU utilization exceeded ${THRESHOLD}% on $HOST - Current usage: $CPU_USED%"
        echo "$BODY" | mail -s "$SUBJECT" "$TO_EMAIL"
        
        # Wait until it drops
        while [ "$CPU_USED" -ge "$THRESHOLD" ]; do
            sleep 60
            if command -v mpstat >/dev/null 2>&1; then
                CPU_USED=$(mpstat 1 1 | awk '/Average:/ {print 100 - $12}')
            else
                CPU_USED=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
            fi
            CPU_USED=$(printf "%.0f" "$CPU_USED")
        done
    fi

    # Wait before next check
    sleep 10
done
