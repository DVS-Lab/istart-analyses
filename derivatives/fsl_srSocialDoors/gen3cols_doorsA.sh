#!/usr/bin/env bash

maindir=`pwd`
baseout=EVfiles/

sub=$1
nruns=1
echo $maindir && echo $baseout
for run in `seq $nruns`; do

  input=${sub}/sub-${sub}_ses-1_task-socialReward_imageA_events.tsv
  output=${baseout}/sub-${sub}/socialReward_doorsA
  mkdir -p $output
  if [ -e $input ]; then
    bash BIDSto3col.sh $input ${output}/run-0${run}
  else
    echo "PATH ERROR: cannot locate ${input}."
    exit
  fi
done

