 	#!/bin/bash

# Function to get timestamp with nanoseconds
get_timestamp() {
  date +"%Y-%m-%d %H:%M:%S.%N %Z"
}

# Function to get CPU usage percentage
get_cpu_usage() {
  top -bn1 | awk '/^%Cpu/ {print int($2)}'
}

# Function to get RAM usage percentage
get_ram_usage() {
  free | awk '/Mem:/ {printf "%.0f", $3/$2*100}'
}

# Function to get storage percentage
get_storage_percentage() {
  df -h --output=pcent / | sed -n '2p' | tr -d '[:space:]'
}

# Function to capture network packets using tshark on eth0
capture_packets() {
  sudo tshark -c 1 -i eth0
}

# Function to log data to the intrusion detection log file
log_to_intrusion_log() {
  local timestamp="$1"
  local cpu_usage="$2"
  local ram_usage="$3"
  local storage_percentage="$4"
  local network_packets="$5"

  local intrusion_log="./intrusion_detection_log.txt"

  # Create the log file if it doesn't exist
  touch "$intrusion_log"

  echo "Timestamp: $timestamp" >> "$intrusion_log"
  echo "-----------------------------------" >> "$intrusion_log"
  echo "CPU Usage: $cpu_usage%" >> "$intrusion_log"
  echo "RAM Usage: $ram_usage%" >> "$intrusion_log"
  echo "Storage Percentage: $storage_percentage" >> "$intrusion_log"
  echo -e "\nCaptured Network Packet:" >> "$intrusion_log"
  echo -e "$network_packets" >> "$intrusion_log"
  echo "----------------------------------------------------" >> "$intrusion_log"

  echo "Data appended to $intrusion_log"
}

# Variables for initial resource values
prev_cpu_usage=$(get_cpu_usage)
prev_ram_usage=$(get_ram_usage)
prev_storage_percentage=$(get_storage_percentage)

# Trap interrupt signal (Ctrl+C)
trap 'cleanup' INT

# Function to clean up and stop the script
cleanup() {
  echo "Stopping intrusion detection."

  # Get timestamp for the final log entry
  final_timestamp=$(get_timestamp)

  # Log final data to the intrusion detection log file
  log_to_intrusion_log "$final_timestamp" "$prev_cpu_usage" "$prev_ram_usage" "$prev_storage_percentage" "Script terminated."

  exit 0
}

# Main loop for intrusion detection
while true; do
  # Get timestamp
  timestamp=$(get_timestamp)

  # Log timestamp
  echo "Timestamp: $timestamp"

  # Log CPU usage
  cpu_usage=$(get_cpu_usage)
  echo "CPU Usage: $cpu_usage%"

  # Log RAM usage
  ram_usage=$(get_ram_usage)
  echo "RAM Usage: $ram_usage%"

  # Log storage percentage
  storage_percentage=$(get_storage_percentage)
  echo "Storage Percentage: $storage_percentage"

  # Capture network packets on eth0
  network_packets=$(capture_packets)
  echo -e "\nCaptured Network Packet:"
  echo -e "$network_packets"

  # Log data to the intrusion detection log file
  log_to_intrusion_log "$timestamp" "$cpu_usage" "$ram_usage" "$storage_percentage" "$network_packets"

  # Update previous values
  prev_cpu_usage="$cpu_usage"
  prev_ram_usage="$ram_usage"
  prev_storage_percentage="$storage_percentage"

  # Check for user input to end detection
  read -t 1 -p "Type 'detection-stop' to stop intrusion detection: " input

  if [ "$input" == "detection-stop" ]; then
    cleanup
  fi

  # Sleep for 1 second before the next iteration
  sleep 1
done

