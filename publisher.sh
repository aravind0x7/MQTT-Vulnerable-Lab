#!/bin/bash

# Loop to continuously publish messages to the MQTT broker
while true; do
    mosquitto_pub -t 'topic_1' -h localhost -m "Data 1" -r -u admin -P admin
    sleep 5
    mosquitto_pub -t 'topic_2' -h localhost -m "Data 2" -r -u admin -P admin
    sleep 5
    mosquitto_pub -t 'topic_3' -h localhost -m "Data 3" -r -u admin -P admin
    sleep 3
done
