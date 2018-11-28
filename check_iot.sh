#!/bin/bash
##send "ICMP request" to iot devices
##check ARP table whether connect or disconnect on the same network
##loop for 50 clients

time=1
file=/etc/dhcp/iot_client.conf


hosts_ip=(`cat $file | awk '{print $2}'`)
hosts_mac=(`cat $file | awk '{print $3}'`)
hosts_name=(`cat $file | awk '{print $1}'`)

for ((i=0; i<${#hosts_ip[@]}; i++))

do
   echo  "Host:${hosts_name[$i]}, IP:${hosts_ip[$i]}, MAC:${hosts_mac[$i]}"
   fping -c $time ${hosts_ip[$i]} 
   if [ $? == 0 ]
   then
      
      macaddr=`arp -a | grep ${hosts_ip[$i]} | awk '{print $4}' | tr 'a-z' 'A-Z'`

      if [ $macaddr == ${hosts_mac[$i]} ] ;then
     	   echo " --> Pass" 
           echo "Host:${hosts_name[$i]} --> Error device ,check ${hosts_mac[$i]}-${hosts_ip[$i]} `date '+%m%d-%X'`" >> alive_devices
      else
           echo "---> Fail"
	       echo "Host:${hosts_name[$i]} --> Error device ,check ${hosts_mac[$i]}-${hosts_ip[$i]} `date '+%m%d-%X'` " >> dead_devices
      
      fi
   else
      echo  ${hosts_ip[$i]} is down
      echo  "plase check ${hosts_name[$i]}" 
      sleep 3

   fi
   echo "=========================================="
done

echo total:${#hosts_ip[@]} clients

