#!/bin/bash
# utilites.sh
# The contents of this file are released under the GNU General Public License. Feel free to reuse the contents of this work, as long as the resultant works give proper attribution and are made publicly available under the GNU General Public License.
# By Arun Sori <arunsori94@gmail.com>
# Shell script for some useful system statistics and generating warnings when exceeding the limits of memory and RAM.
# Can be useful for running on a server as a cronjob.



#Get the cpu usage and compare it with warning level

#mail id
mail_id=somerandomid@example.com

time_stamp=`date`
#set warning level
declare -i warn=70

#get cpu_usage
cpu_us=`top -n 1 -b | awk '/%Cpu/ { print $2} '`

#just to clear spaces in  case
usage=`echo $cpu_us | awk '/[0-9]/' | awk '{print $1}'`

#getting true(1) or false(0) for cpu usage above 70%
let re=`echo "$cpu_us > $warn " | bc`

if [ $re -eq 1 ];
then 
echo "Warning...."

echo "Cpu Usage above $warn%!!" | mail -s "Warning! from $HOSTNAME at $time_stamp" $mail_id

fi


#HDD Warning

#set warning level
let warn_hdd=90

#Get used % of Hard Disk 
hdd=`df --total | awk '/total/ { print $5}' | sed 's/%//g'`

#convert to integer

let used=`echo "$hdd+0" | bc`

#check if used hard disk is greater than warning level

if [ $used -gt $warn_hdd ];
then
echo "Warning!! Hard Disk is Used more than $warn_hdd%" | mail -s "Warning!! from $H0STNAME at $time_stamp" $mail_id
echo "Mail Sent"
fi

#Generation of a simple Memory Status
#system name
sys=`uname -orp`

#number of processors
proc=`nproc --a`

#Memory Status
mem=`free -h | head -n 2`

#Swap status
swap=`free -h | tail -n 1`

#idle time
idle=`top -n1 | grep %Cpu | cut -d, -f4`

#Used time
use=`top -n1 | grep %Cpu | cut -d, -f1`

#Total Number Of processes
prs=`ps -ef | wc -l`

echo "System Information For $sys"
echo -e "\n"
 
echo "Cpu Information"
echo "Number of Cores:   $proc"
echo "Idle:   $idle"
echo "Used:   $use"
echo "Total Number of Processes:   $prs"

echo "HDD Information"
#getting Free space excluding tmpfs and devtmpfs filesystems

echo "$(df -h -x"tmpfs" -x"devtmpfs")"

#For Memory Consumption More than 98%
warn_mem=98

#Getting Total Memory

#tot_mem=`top -n 1 -b | head -n 4 | awk '/Mem/' | awk '{print $3}'`

#rem_mem=`top -n 1 -b | head -n 4 | awk '/Mem/' | awk '{print $5}'`

#buffer=`top -n 1 -b | head -n 4 | awk '/Mem/' | awk '{print $9}'`

#getting actual % of memory Used
per=`free | grep Mem | awk '{print ($3-$7)/$2*100}'`

#checking if memory used is more than 98 % (0 or 1)
rem=`echo "$per > $warn_mem" | bc`

if [ $rem -eq 1 ];
then 
echo "Warning"
echo "Memory Usage above $warn_mem%!!" | mail -s "Warning! from $HOSTNAME at $time_stamp" $mail_id
fi

