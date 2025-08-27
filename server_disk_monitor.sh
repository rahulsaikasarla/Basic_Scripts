#!/bin/bash
THRESHOLD=80
TO_EMAIL="rahool.kasarla1212@gmail.com"
HOST=$(hostname)

while true; do
    DISK_USED=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    echo "Disk Usage (/): $DISK_USED%"
    if [ "$DISK_USED" -ge "$THRESHOLD" ]; then
        SUBJECT="Dev-Server-Disk-Utilization-Alert-on-$HOST"
        BODY="Warning: Disk utilization exceeded ${THRESHOLD}% on / - Current usage: ${DISK_USED}%"
        echo "$BODY" | mail -s "$SUBJECT" "$TO_EMAIL"
    fi
    sleep 10
done
