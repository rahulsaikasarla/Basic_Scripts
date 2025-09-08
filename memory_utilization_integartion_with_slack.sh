#!/bin/bash
SLACK_WEB='https://hooks.slack.com/services/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'
SERVER_NAME=$(curl -sL http://169.254.169.254/latest/meta-data/local-hostname)
TOTAL_MEM=$(free -m | grep -i mem | awk -F " " '{print $2}')
TOTAL_AVL=$(free -m | grep -i mem | awk -F " " '{print $7}')
USED_MEMORY=$(expr $TOTAL_MEM - $TOTAL_AVL)
echo "The Total Memory In The Machine Is ${TOTAL_MEM}MB and CURRENT UTILIZATION IS ${USED_MEMORY}MB"
X=$(echo "scale=2; $TOTAL_AVL / $TOTAL_MEM" | bc | tr -d '.')
echo "The Free Memory Percentrage is ${X}%."
CURRENT_UTIL_PER=$(expr 100 - $X)
if [ $X -lt 10 ]; then
    #if (($X <= 40)); then
    echo "Current Memory Utilization of Server ${SERVER_NAME} is ${CURRENT_UTIL_PER}% "
    curl -X POST ${SLACK_WEB} -sL -H 'Content-type: application/json' --data "{"text": \"Current Memory Utilization of Server ${SERVER_NAME} is: ${CURRENT_UTIL_PER}\"}" >>/dev/null
else
    echo "Current Memory Utilization is ${CURRENT_UTIL_PER}% and within the limits."
fi
