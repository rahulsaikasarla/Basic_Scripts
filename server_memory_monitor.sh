#!/bin/bash
THRESHOLD=80
TO_EMAIL="rahool.kasarla1212@gmail.com"
HOST=$(hostname)

while true; do
    MEM_USED=$(free | awk '/Mem/ { printf("%.0f", $3/$2 * 100) }')
    echo "Memory Usage: $MEM_USED%"
    if [ "$MEM_USED" -ge "$THRESHOLD" ]; then
        SUBJECT="Dev-Server-Memory-Utilization-Alert-on-$HOST"
        BODY="Warning: Memory utilization exceeded ${THRESHOLD}% - Current usage: ${MEM_USED}%"
        echo "$BODY" | mail -s "$SUBJECT" "$TO_EMAIL"
    fi
    sleep 10
done
