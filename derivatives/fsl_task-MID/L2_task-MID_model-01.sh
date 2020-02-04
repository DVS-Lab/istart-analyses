#!/usr/bin/env bash

maindir="/data/projects/istart-analyses"

task=MID

sub=$1
nruns=$2
sm=$3
dtype=dctAROMAnonaggr

MAINOUTPUT=${maindir}/derivatives/fsl_task-${task}/sub-${sub}

NCOPES=13
INPUT1=${MAINOUTPUT}/L1_task-${task}_model-01_type-act_run-01_sm-${sm}_variant-dctAROMAnonaggr.feat
INPUT2=${MAINOUTPUT}/L1_task-${task}_model-01_type-act_run-02_sm-${sm}_variant-dctAROMAnonaggr.feat

OUTPUT=${MAINOUTPUT}/L2_task-${task}_model-01_type-act_sm-${sm}
if [ -e ${OUTPUT}.gfeat/cope${NCOPES}.feat/cluster_mask_zstat1.nii.gz ]; then
	echo "skipping existing output"
else
	rm -rf ${OUTPUT}.gfeat

	ITEMPLATE=${maindir}/derivatives/fsl_task-${task}/templates/L2_task-${task}_model-01_type-act.fsf
	OTEMPLATE=${MAINOUTPUT}/L2_task-${task}-01_type-act.fsf
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@INPUT1@'$INPUT1'@g' \
	-e 's@INPUT2@'$INPUT2'@g' \
	<$ITEMPLATE> $OTEMPLATE
	feat $OTEMPLATE

	# delete unused files
	for cope in `seq ${NCOPES}`; do
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/res4d.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/corrections.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/threshac1.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/filtered_func_data.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/var_filtered_func_data.nii.gz
	done

fi
