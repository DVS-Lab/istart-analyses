#!/usr/bin/env bash

maindir='/data/projects/istart-analyses'

sub=$1
nruns=2
sm=6
dtype=dctAROMAnonaggr

MAINOUTPUT=${maindir}/derivatives/fsl_task-sharedreward/sub-${sub}

# Shared Reward Task
NCOPES=19
INPUT1=${MAINOUTPUT}/L1_task-sharedreward_model-01_type-act_run-01_sm-${sm}_variant-${dtype}.feat
INPUT2=${MAINOUTPUT}/L1_task-sharedreward_model-01_type-act_run-02_sm-${sm}_variant-${dtype}.feat

OUTPUT=${MAINOUTPUT}/L2_task-sharedreward_model-01_type-act_sm-${sm}_variant-${dtype}
if [ -e ${OUTPUT}.gfeat/cope${NCOPES}.feat/cluster_mask_zstat1.nii.gz ]; then
	echo "skipping existing output"
else
	echo "re-doing: ${OUTPUT}" >> re-runL2.log
	rm -rf ${OUTPUT}.gfeat
	
	ITEMPLATE=${maindir}/derivatives/fsl_task-sharedreward/templates/L2_task-sharedreward_model-01_type-act.fsf
	OTEMPLATE=${MAINOUTPUT}/L2_task-sharedreward_model-01_type-act_variant-${dtype}.fsf
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



