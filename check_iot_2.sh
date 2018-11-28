#!/bin/bash
##send "ICMP request" to iot devices
##check ARP table whether connect or disconnect on the same network
##loop for 50 clients

time=2

file=/etc/dhcp/iot_client.conf

hosts_ip=(`cat $file | awk '{print $2}'`)
hosts_mac=(`cat $file | awk '{print $3}'`)
hosts_name=(`cat $file | awk '{print $1}'`)

fping -c $time ${hosts_ip[*]}

macaddr=`arp -a  | awk '{print $4}' | tr 'a-z' 'A-Z'`

for ((i=0; i<${#hosts_ip[@]}; i++))

do
    echo -n "Host:${hosts_name[$i]}, IP:${hosts_ip[$i]}, MAC:${hosts_mac[$i]}" 
    macaddr=`arp -a | grep ${hosts_ip[$i]} | awk '{print $4}' | tr 'a-z' 'A-Z'`
    if [ $macaddr == ${hosts_mac[$i]} ] ;then
        echo " --> Pass" 
        echo "Host:${hosts_name[$i]} --> Error device ,check ${hosts_mac[$i]}-${hosts_ip[$i]} `date '+%m%d-%X'`" >> alive_devices
    else
        echo "---> Fail"
    	echo "Host:${hosts_name[$i]} --> Error device ,check ${hosts_mac[$i]}-${hosts_ip[$i]} `date '+%m%d-%X'` " >> dead_devices
    fi
echo "========================================================================="
done

echo total:${#hosts_ip[@]} clients

