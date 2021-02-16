#!/bin/bash 
#A master script to copy the decoded runs from /data2/ area and run it in grid
#Author: Abinash pun

#variables to use the updated proxy certificate
export ROLE=Analysis
export X509_USER_PROXY=/var/tmp/${USER}.${ROLE}.proxy


dir_scripts=$(dirname $(readlink -f $BASH_SOURCE))

#grid setup script
source /e906/app/software/script/setup-jobsub-spinquest.sh

##list out all the decoded runs and save the runid (by kenichi)
mysql --defaults-file=/data2/e1039/resource/db_conf/my_db1.cnf     --batch --skip-column-names     --execute='select run_id from deco_status where deco_status = 2 order by run_id desc'     user_e1039_maindaq >$dir_scripts/list.txt

##find out the difference between the two list and copy it to pnfs/e1039/tape_backed/decoded_data area
grep -vxf $dir_scripts/list_hold.txt $dir_scripts/list.txt >$dir_scripts/run_list.txt

##Loop over new decoded data
while read line; do
  ##Reading each line
  echo $line
  
  run_dir=($(printf 'run_%06d' $line) )
  echo $run_dir
  
  ##no. of splits in corresponding run
  n_splits=$(ls /data2/e1039/dst/$run_dir/ | wc -l)
  echo $n_splits

  if [ $n_splits -gt 1 ]; then #choose the runs with more than 1 splits only

    #copy the decoded data to tape_backed area
    cp -r /data2/e1039/dst/$run_dir /pnfs/e1039/tape_backed/decoded_data

    #submit the grid job
    $dir_scripts/gridsub_data.sh $run_dir 1 $line 0 splitting

    #submitted list
    echo $line >>$dir_scripts/submitted_list.txt

  fi

done <$dir_scripts/run_list.txt

##update the holding list
cat $dir_scripts/run_list.txt >>$dir_scripts/list_hold.txt

