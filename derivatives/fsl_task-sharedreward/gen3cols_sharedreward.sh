#!/usr/bin/env bash

maindir=`pwd`
baseout=EVfiles/

sub=$1
nruns=$2
echo $maindir && echo $baseout
for run in `seq $nruns`; do

  input=bids/sub-${sub}/func/sub-${sub}_task-sharedreward_run-0${run}_events.tsv
  output=${sub}/sharedreward
  mkdir -p $output
  if [ -e $input ]; then
    bash BIDSto3col.sh $input ${output}/run-0${run}
  else
    echo "PATH ERROR: cannot locate ${input}."
    exit
  fi
done

