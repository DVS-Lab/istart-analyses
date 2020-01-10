#!/usr/bin/env bash

sourcedata=/data/sourcedata/istart/dicoms
sub=$1
dsroot=`pwd`

singularity run \
  --cleanenv \
  -B `pwd`:/out \
  -B $sourcedata:/sourcedata \
  /data/tools/heudiconv-0.5.4.simg \
  -d /sourcedata/Smith-ISTART-{subject}/scans/*/DICOM/*.dcm \
  -s $sub \
  -f convertall \
  -c none \
  --minmeta \
  -o /out

     
