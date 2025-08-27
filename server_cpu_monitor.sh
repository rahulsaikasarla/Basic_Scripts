#!/bin/bash
THRESHOLD=80
TO_EMAIL="rahool.kasarla1212@gmail.com"
HOST=$(hostname)

while true; do
    if command -v mpstat >/dev/null 2>&1; then
        CPU_USED=$(mpstat 1 1 | awk '/Average/ {print 100 - $12}')
    else
        CPU_USED=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    fi

    # Round CPU usage
    CPU_USED_INT=$(printf "%.0f" "$CPU_USED")
    echo "CPU Usage: $CPU_USED_INT%"
    if [ "$CPU_USED_INT" -ge "$THRESHOLD" ]; then
        SUBJECT="Dev-Server-CPU-Utilization-Alert-on-$HOST"
        BODY="Warning: CPU utilization exceeded ${THRESHOLD}% - Current usage: ${CPU_USED_INT}%"
        echo "$BODY" | mail -s "$SUBJECT" "$TO_EMAIL"
    fi
    sleep 10
done
