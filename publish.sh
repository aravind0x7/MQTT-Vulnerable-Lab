#!/bin/bash

while :
do
    mosquitto_pub -t 'updates' -h 127.0.0.1 -m "{\"d\": \"Data_1\"}" -r
    sleep 5
    mosquitto_pub -t 'updates' -h 127.0.0.1 -m "{\"d\": \"Data_2\"}" -r
    sleep 5
    mosquitto_pub -t "updates" -h 127.0.0.1 -m "{\"d\": \"Data_3\"}"
    sleep 3
done
