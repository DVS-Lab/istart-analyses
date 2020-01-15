#!/bin/bash

sub=$1 

singularity run \
    --cleanenv \
    -B /data/projects/istart-analyses/:/base \
    -B /data/tools/licenses:/opts \
    -B /data/scratch/caleb:/scratch \
    -B /data/projects/istart-analyses/bids:/sourcedata \
    /data/tools/fmriprep-1.5.3.simg \
    /sourcedata /base/derivatives/ \
    participant --participant_label $sub \
    --use-aroma --fs-no-reconall \
    --fs-license-file /opts/fs_license.txt \
    -w /scratch/caleb

