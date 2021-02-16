#!/bin/bash
#Script for reusbmission of failed grid jobs (bad job nodes and mysql server error)

dir_macros=$(dirname $(readlink -f $BASH_SOURCE))

source /e906/app/software/script/setup-jobsub-spinquest.sh

#loop over submitted runs after ~1 hour of job submission
while read run_name; do

    run_dir=($(printf 'run_%06d' $run_name) )
    
    #loop over the log files of the submitted runs
    for i in /pnfs/e1039/persistent/cosmic_recodata/$run_dir/*/log/log.txt; do
	
	reco_status=$(tail -1 "$i" | head -1) #reco_status from root -l {macro} command in gridrun_data.sh	
	
	if [ "$reco_status" != "0" ]; then #if there is error

            resub_file=$(tail -2 "$i" | head -1) #data file cout from gridrun
            resub_file_dir=${resub_file%'.root'}

	    #remove the log and output files if any   
            rm /pnfs/e1039/persistent/cosmic_recodata/$run_dir/$resub_file_dir/log/log.txt
	    rm /pnfs/e1039/persistent/cosmic_recodata/$resub_file_dir/out/*.root
	    
	    #resubmit the grid job
	    ./gridsub_play_resub.sh $run_dir 1 $run_name 0 splitting $resub_file

	fi
    done

done <$dir_macros/submitted_list.txt
