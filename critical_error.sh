# backup.sh
# The contents of this file are released under the GNU General Public License. Feel free to reuse the contents of this work, as long as the resultant works give proper attribution and are made publicly available under the GNU General Public License.
# By Arun Sori <arunsori94@gmail.com>

#!/bin/bash

#To find any critical error in the syslog...file

#give filename for setting prev execution time
time_file=tim_f

#syslog file here....
sys_file=/var/log/syslog

#info file here
info_file=info

#reading from time_File
                                                                                                                                                
if [ -a $time_file ];
then

prev_time=`cat $time_file | cut -d' ' -f3` 
prev_mnth=`cat $time_file | cut -d' ' -f1`
prev_date=`cat $time_file | cut -d' ' -f2`
now=`date | awk '{print $4}'`
now_date=`date | awk '{print $3}'`

fi

#checking the file for condition

if [ -a $sys_file ];
then 

#Here the pattern is searched for in between the given times....set the error tag at the last awk call
cat $sys_file | nawk '
function gday (y, m, d)   #to convert date to days...
{
    m =  ( m + 9 ) % 12         # mar=0, feb=11                                                                                                                          
    y = y - int(m/10)           # if Jan/Feb, year--                                                                                                                     
    return y * 365 + int(y/4) - int(y/100) + int(y/400) + int(0.5 + m * 30.6) + (d - 1)
}
function mth_nam(mnth)
{
    if(mnth ~ "Jan")
    {return 1}
    if(mnth ~ "Feb")
    {return 2}
    if(mnth ~ "Mar")
    {return 3}
    if(mnth ~ "Apr")
    {return 4}
    if(mnth ~ "May")
    {return 5}
    if(mnth ~ "Jun")
    {return 6}
    if(mnth ~ "Jul")                                                                                                                                                 
    {return 7}
    if(mnth ~ "Aug")                                                                                                                                                  
    {return 8}
    if(mnth ~ "Sep")                                                                                                                                                   
    {return 9}                                                                                                                                                       
    if(mnth ~ "Oct")                                                                                                                                                     
    {return 10}                                                                                                                                                          
    if(mnth ~ "Nov")                                                                                                                                                     
    {return 11}                                                                                                                                                          
    if(mnth ~ "Dec")
    {return 12}                                      
}
{ 
   mnth=mth_nam($1);
   pp_mnth=mth_nam(p_mnth);
   date=gday(2013,mnth,$2);
   pp_date=gday(2013,pp_mnth,p_date);
   if(date ~ pp_date)
  { if($3<no && $3>prev_ti){ print $0} }
   if( date > pp_date)
  { if(($3 > prev_ti && date ~ pp_date)||(date > pp_date && $3<no)) { print $0} }

}
' no=$now prev_ti=$prev_time p_date=$prev_date p_mnth=$prev_mnth | awk '//' | tee $info_file  #<---give error call here.. change to /sm text/ to get any "sm text" from log

fi


#set the run_time to time_file
echo `date | cut -d' ' -f2,3,4` > $time_file


