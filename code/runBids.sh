#!/bin/bash

sub=$1
sourcedata=/data/sourcedata/istart/

#part one, run heuristic dicom to BIDS converter from container
singularity run \
  --cleanenv \
  -B /data/projects/istart-analyses/code:/code \
  -B /$sourcedata:/sourcedata \
  -B /data/projects/istart-analyses:/out \
  /data/tools/heudiconv-0.5.4.simg \
  -d /sourcedata/dicoms/Smith-ISTART-{subject}/scans/*/DICOM/*.dcm -s $sub \
  -f /code/heuristic.py \
  -c dcm2niix -b \
  --minmeta \
  -o /out/bids \
  --overwrite

#change permissions, fix field map
sudo chmod -R 777 /data/projects/istart-analyses/bids
python addIntendedFor.py

#deface anatomicals for compatability with data sharing
bidsroot=/data/projects/istart-analyses/bids
pydeface.py ${bidsroot}/sub-${sub}/anat/sub-${sub}_T1w.nii.gz
mv -f ${bidsroot}/sub-${sub}/anat/sub-${sub}_T1w_defaced.nii.gz ${bidsroot}/sub-${sub}/anat/sub-${sub}_T1w.nii.gz

#run automated QC
singularity run --cleanenv \
    -B /data/projects/istart-analyses/bids:/base \
    -B /data/projects/istart-analyses/derivatives/mriqc:/out \
    -B /data/scratch/caleb:/scratch/ \
    /data/tools/mriqc-0.15.1.simg \
    /base /out \
    participant --participant_label $sub --fft-spikes-detector --ica -w /scratch
