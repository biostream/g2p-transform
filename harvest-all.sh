#!/bin/bash

#
# Harvest g2p information.
# Default will harvest all. set HARVESTERS csv variable to specify
# Default will harvest and write files to /output.  set OUTPUT_DIR env variable to specify

default_harvesters=cgi_biomarkers,jax,civic,oncokb,pmkb,molecularmatch,sage,jax_trials,brca
HARVESTERS=${HARVESTERS:-$default_harvesters}
# split on comma
IFS=',' read -ra MY_HARVESTERS <<< "$HARVESTERS"

OUTPUT_DIR=${OUTPUT_DIR:-"/output"}
echo "starting harvesters:[" "${MY_HARVESTERS[@]}"  "] writing to " $OUTPUT_DIR

# keep track of what failed
FAIL=0

for h in "${MY_HARVESTERS[@]}"
do
	python harvester.py --harvesters $h --silo file -o $OUTPUT_DIR  &
done

for job in `jobs -p`
do
echo $job
    wait $job || let "FAIL+=1"
done


if [ "$FAIL" == "0" ];
then
echo "All harvesters succeeded"
else
echo "($FAIL) harvesters failed"
fi
