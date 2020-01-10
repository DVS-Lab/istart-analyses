#!/bin/bash

sub=$1
nruns=2

#part one, run heuristic dicom to BIDS converter from container
singularity run \
  --cleanenv \
  -B /data/sourcedata/istart/code:/code \
  -B /data/sourcedata/istart/dicoms:/base \
  -B /data/projects/istart-analyses/bids:/out \
  /data/tools/heudiconv-0.5.4.simg \
  -d /base/Smith-ISTART-{subject}/scans/*/DICOM/*.dcm -s $sub \
  -f /code/heuristic.py \
  -c dcm2niix -b \
  --minmeta \
  -o /out \
  --overwrite

#change permissions, fix field map
chmod -R 777 /data/projects/istart-analyses/bids
python addIntendedFor.py

#deface anatomicals for compatability with data sharing
bidsroot=/data/projects/istart-analyses/bids
pydeface.py ${bidsroot}/sub-${sub}/anat/sub-${sub}_T1w.nii.gz
mv -f ${bidsroot}/sub-${sub}/anat/sub-${sub}_T1w_defaced.nii.gz ${bidsroot}/sub-${sub}/anat/sub-${sub}_T1w.nii.gz

#make a derivatives folder if one does not exist 
if [ ! -d /projects/istart-analyses/derivatives/mriqc ]; then
        mkdir -p /data/sourcedata/istart/derivatives/mriqc
    fi
#run automated QC
singularity run --cleanenv \
    -B /data/projects/istart-analyses/bids:/data \
    -B /data/projects/istart-analyses/derivatives/mriqc:/out \
    -B /data/scratch:/scratch/caleb \
    /data/tools/mriqc-0.15.1.simg \
    /data /out \
    participant --participant_label $sub --fft-spikes-detector --ica -w /scratch



