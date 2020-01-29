#!/bin/bash

# TODO
# 1) execute with datalad run -m "message" --input "derivatives/fmriprep/*" --output "derivatives/fsl/*" "bash run_L1stats.sh"
# 2) test with subject-specific inputs/ouputs 
# 3) adjust input/output structure (don't need to be writing to derivatives/fmriprep)


for sm in 6; do
	for ppi in 0; do #VS Amyg FFA; putting 0 first will indicate "activation"
		for subrun in "1001 1" "1002 1" "1003 1" "1004 1" "1006 1"; do

		  set -- $subrun
		  sub=$1
		  nruns=$2
		  #echo "$sub $nruns"
		
		  for run in `seq $nruns`; do
		  	#Manages the number of jobs and cores
		  	SCRIPTNAME=code/L1_task-srSocial_model-01.sh
		  	NCORES=7
		  	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
		    		sleep 1s
		  	done
		  	bash $SCRIPTNAME $sub $run $ppi $sm &
		  	sleep 1s
          done  

          for run in `seq $nruns`; do
		  	#Manages the number of jobs and cores
		  	SCRIPTNAME=code/L1_task-srDoors_model-01.sh
		  	NCORES=7
		  	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
		    		sleep 1s
		  	done
		  	bash $SCRIPTNAME $sub $run $ppi $sm &
		  	sleep 1s
		  done

		done
	done
done


# wait to exit so logging is correct in datalad run command
while [ $(ps -ef | grep -v grep | grep code/L1_task-srSocial_model-01.sh | wc -l) -ge 1 ]; do
	sleep 5m
	echo "STATUS: code/L1_task-srSocial_model-01.sh is waiting to complete at `date`"
done

while [ $(ps -ef | grep -v grep | grep code/L1_task-srDoors_model-01.sh | wc -l) -ge 1 ]; do
	sleep 5m
	echo "STATUS: code/L1_task-srDoors_model-01.sh is waiting to complete at `date`"
done



