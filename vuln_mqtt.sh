#!/bin/bash

# Function to get the IP address of the system
get_ip_address() {
    ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d'/' -f1
}

# Function to start the Mosquitto broker
start_mosquitto() {
    echo -e "\e[34mStarting Mosquitto broker in verbose mode...\e[0m"
    nohup mosquitto -c /etc/mosquitto/mosquitto.conf -v > mosquitto.log 2>&1 &
    MOSQUITTO_PID=$!
    sleep 5  # Give it a moment to start
    if ! ps -p $MOSQUITTO_PID > /dev/null; then
        echo -e "\e[31mFailed to start Mosquitto. Please check the installation and configuration.\e[0m"
        exit 1
    fi
    echo -e "\e[32mMosquitto broker started successfully (PID: $MOSQUITTO_PID).\e[0m"
}

# Function to start the publisher script
start_publisher() {
    echo -e "\e[34mStarting publisher script...\e[0m"
    nohup ./publisher.sh > publisher.log 2>&1 &
    PUBLISHER_PID=$!
    sleep 2  # Give it a moment to start
    if ! ps -p $PUBLISHER_PID > /dev/null; then
        echo -e "\e[31mFailed to start publisher script.\e[0m"
        exit 1
    fi
    echo -e "\e[32mPublisher script started successfully (PID: $PUBLISHER_PID).\e[0m"
}

# Function to display ASCII art
display_ascii_art() {
    echo -e "\e[33m"
    echo "             .__                                     __    __   "
    echo " ___  ____ __|  |   ____             _____   _______/  |__/  |_ "
    echo " \  \/ /  |  \  |  /    \   ______  /     \ / ____/\   __\   __|"
    echo "  \   /|  |  /  |_|   |  \ /_____/ |  Y Y  < <_|  | |  |  |  |  "
    echo "   \_/ |____/|____/___|  /         |__|_|  /\__   | |__|  |__|  "
    echo "                       \/                \/    |__|             "
    echo "                                                "
    echo -e "\e[0m"
}

# Main script execution
main() {
    display_ascii_art
    echo -e "\e[34mStarting MQTT vulnerable lab...\e[0m"

    # Get the IP address of the system
    IP_ADDRESS=$(get_ip_address)
    if [[ -z "$IP_ADDRESS" ]]; then
        echo -e "\e[31mFailed to retrieve IP address. Please check your network settings.\e[0m"
        exit 1
    fi

    # Start the Mosquitto broker
    start_mosquitto

    # Display the IP address and port
    echo -e "\e[32mMQTT Broker is running on IP: \e[1m$IP_ADDRESS\e[0m"
    echo -e "\e[32mPort: \e[1m1883\e[0m"

    # Start the publisher script
    start_publisher

    # Keep the script running to keep the publisher active
    echo -e "\e[34mPress [CTRL+C] to stop the server...\e[0m"
    while true; do
        sleep 60
    done
}

# Run the main function
main
