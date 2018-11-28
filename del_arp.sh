#!/bin/bash

file=/etc/dhcp/iot_client.conf
hosts_ip=(`cat $file | awk '{print $2}'`)

for ((i=0; i<${#hosts_ip[@]}; i++))

do
      arp -d ${hosts_ip[$i]}
      
done

arp -i eth0

