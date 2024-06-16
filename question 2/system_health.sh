#!/bin/bash

# Define thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="system_health.log"

# Function to get CPU usage
get_cpu_usage() {
    top -bn1 | grep "Cpu(s)" | \
           sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
           awk '{print 100 - $1}'
}

# Function to get memory usage
get_memory_usage() {
    free | awk '/Mem/ {print $3/$2 * 100.0}'
}

# Function to get disk usage
get_disk_usage() {
    df / | awk '/\// {print $5}' | sed 's/%//'
}

# Function to get the number of running processes
get_running_processes() {
    ps aux | wc -l
}

# Function to log alerts
log_alert() {
    local message=$1
    echo "$(date): $message" >> $LOG_FILE
}

# Main monitoring function
monitor_system() {
    local cpu_usage=$(get_cpu_usage)
    local memory_usage=$(get_memory_usage)
    local disk_usage=$(get_disk_usage)
    local running_processes=$(get_running_processes)

    # Check CPU usage
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
        log_alert "CPU usage is above threshold: ${cpu_usage}%"
    fi

    # Check memory usage
    if (( $(echo "$memory_usage > $MEMORY_THRESHOLD" | bc -l) )); then
        log_alert "Memory usage is above threshold: ${memory_usage}%"
    fi

    # Check disk usage
    if (( disk_usage > DISK_THRESHOLD )); then
        log_alert "Disk usage is above threshold: ${disk_usage}%"
    fi

    # Log running processes (just logging the count)
    log_alert "Number of running processes: ${running_processes}"
}

# Run the monitoring function
monitor_system

