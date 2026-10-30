#!/bin/bash

disk_usage=$(df -h |grep -v Filesystem)
usage_threshold=30
msg=""


R="\e[31m"
G="\e[32m"
N="\e[0m"

host=$(hostname)

echo -e "Disk usage report on ${R}....${host}....${N}"

while IFS= read -r line
do
    usage=$(echo "$line" | awk '{print $5}' | cut -d "%" -f1)
    partition=$(echo "$line" | awk '{print $6}')

    if [ "$usage" -ge "$usage_threshold" ]; then
        msg+="High disk usage on $partition : ${usage}%"$'\n'
    fi

done <<< "$disk_usage"

if [ -n "$msg" ]; then
    printf "%s" "$msg"
else
    echo "All partitions are below ${usage_threshold}%."
fi
