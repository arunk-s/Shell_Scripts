#!/bin/bash
# backup.sh
# The contents of this file are released under the GNU General Public License. Feel free to reuse the contents of this work, as long as the resultant works give proper attribution and are made publicly available under the GNU General Public License.
# By Arun Sori <arunsori94@gmail.com>

#For taking backup of the desired directory and store it at a remote place

#timestamp
time_stamp=`date`

#backup file name 
#Added date and Hostname on the filename 
bfile=`date +%F`.$HOSTNAME.tar.gz

#Source DIR , change it according to your need
sdir="."

#destination DIR
ddir=backup


#snapshot file name(with path)...change it according to machine
snap=/path/dir/backup.snar



#IP Address with hostname

ip=smth@90.0.0.130							#Give the address of the ssh server where you need to store the backup

echo "Taking Backup From $HOSTNAME at $time_stamp"

if [ -a $snap-1 ];                                     #means that level-0(full) backup has been taken
then

#Takes the incremented backup level-1 or above using file according to $snap and append 1 to the snapshot file 
#Also used a hack for ssh to change directory to $ddir on the ssh server and output the extracted file onto backup file as set by $bfile
tar --listed-incremental=$snap-1 -cvpz $sdir | ssh $ip "cd $ddir; cat > $bfile "


else                                                  #taking full backup  

#Same thing here too but it takes full backup and add prefix "full" on the backup file
tar --listed-incremental=$snap -cvpz $sdir | ssh $ip "cd $ddir; cat > full.$bfile "

#Copy the contents of snapshot file onto a duplicate file $snap-1 so that level-0 backup can be taken anytime
cp $snap $snap-1

fi
