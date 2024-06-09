#!/bin/bash

# Function to get the current date and time
current_datetime() {
    echo "$(date '+%Y-%m-%d %H:%M:%S')"
}

# Function to simulate temperature readings from a smart thermostat
publish_thermostat_data() {
    local temp=$((RANDOM % 10 + 18)) # Random temperature between 18 and 27
    local datetime=$(current_datetime)
    mosquitto_pub -t 'smart_home/thermostat' -h localhost -m "[$datetime] Temperature: $temp°C" -r -u admin -P admin
}

# Function to simulate video feed URLs from a security camera
publish_security_camera_data() {
    local cam_id=$((RANDOM % 4 + 1)) # Random camera ID between 1 and 4
    local datetime=$(current_datetime)
    mosquitto_pub -t "smart_home/security_camera_$cam_id" -h localhost -m "[$datetime] Video feed URL: http://localhost:8080/cam_$cam_id" -r -u admin -P admin
}

# Function to simulate lock status from a smart lock
publish_smart_lock_data() {
    local status=$((RANDOM % 2)) # Random lock status (0 for locked, 1 for unlocked)
    local lock_status="locked"
    if [ $status -eq 1 ]; then
        lock_status="unlocked"
    fi
    local datetime=$(current_datetime)
    mosquitto_pub -t 'smart_home/smart_lock' -h localhost -m "[$datetime] Door is $lock_status" -r -u admin -P admin
}

# Function to simulate leaking sensitive data
leak_sensitive_data() {
    local sensitive_data="WiFi Password: home_wifi_pass123"
    local datetime=$(current_datetime)
    mosquitto_pub -t 'smart_home/sensitive_data' -h localhost -m "[$datetime] $sensitive_data" -r -u admin -P admin
}

# Loop to continuously publish messages to the MQTT broker
while true; do
    publish_thermostat_data
    sleep 5
    publish_security_camera_data
    sleep 5
    publish_smart_lock_data
    sleep 3

    # Randomly leak sensitive data
    if [ $((RANDOM % 10)) -lt 3 ]; then
        leak_sensitive_data
    fi
done
