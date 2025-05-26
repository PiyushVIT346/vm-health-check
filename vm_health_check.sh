#!/bin/bash

# Function to get CPU utilization percentage
get_cpu_usage() {
    # Get the CPU idle value from top, then calculate usage
    cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); print v }')
    cpu_usage=$(awk "BEGIN {print 100 - $cpu_idle}")
    echo "$cpu_usage"
}

# Function to get Memory utilization percentage
get_mem_usage() {
    mem=$(free | grep Mem)
    total=$(echo $mem | awk '{print $2}')
    used=$(echo $mem | awk '{print $3}')
    mem_usage=$(awk "BEGIN {print ($used/$total)*100}")
    echo "$mem_usage"
}

# Function to get highest Disk utilization percentage among all partitions
get_disk_usage() {
    # Exclude tmpfs, udev, loop devices
    disk_usage=$(df -h --output=pcent,target -x tmpfs -x devtmpfs -x squashfs | awk 'NR>1 {gsub("%","",$1); if($1>mx) {mx=$1; mp=$2}} END {print mx}')
    echo "$disk_usage"
}

# Check command line argument
explain=0
if [[ "$1" == "explain" ]]; then
    explain=1
fi

cpu_usage=$(get_cpu_usage)
mem_usage=$(get_mem_usage)
disk_usage=$(get_disk_usage)

status="Healthy"
reason=""

if (( $(echo "$cpu_usage > 60" | bc -l) )); then
    status="Not Healthy"
    reason+="CPU usage is above threshold ($cpu_usage%). "
fi

if (( $(echo "$mem_usage > 60" | bc -l) )); then
    status="Not Healthy"
    reason+="Memory usage is above threshold ($mem_usage%). "
fi

if (( $(echo "$disk_usage > 60" | bc -l) )); then
    status="Not Healthy"
    reason+="Disk usage is above threshold ($disk_usage%). "
fi

echo "Health Status: $status"
if [[ $explain -eq 1 ]]; then
    if [ "$reason" == "" ]; then
        reason="All parameters are within healthy limits. CPU: $(printf "%.2f" "$cpu_usage")%, Memory: $(printf "%.2f" "$mem_usage")%, Disk: $disk_usage%"
    fi
    echo "Reason: $reason"
fi
