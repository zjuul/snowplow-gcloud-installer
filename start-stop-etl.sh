#!/bin/bash

. ./0_set_environment.sh
. ./0_functions.sh

# when the ETL instance is configured, you can use this script to start it up
# (including dataflows)
# .. and shut all of it down (so it won't cost you a lot).



ETL_STATUS=$(gcloud compute instances list | \
		grep "^${GSP_ETL_INSTANCE_NAME}\s" | \
		awk '{print $NF}')

if [ "$1" = "-status" -o "$1" = "status" ] ; then
	echo "Status of '${GSP_ETL_INSTANCE_NAME}' is '$ETL_STATUS'"
	exit 0
fi


if [ "${ETL_STATUS}" == "TERMINATED" ] ; then
	echo "starting up.."
	gcloud compute instances start ${GSP_ETL_INSTANCE_NAME} --zone ${GSP_REGION}
elif [ "${ETL_STATUS}" == "RUNNING" ] ; then
	echo "terminating.."
	gcloud compute instances stop ${GSP_ETL_INSTANCE_NAME} --zone ${GSP_REGION}
	for j in $(gcloud dataflow jobs list | grep Running | awk '{print $1}') ;  do
		gcloud dataflow jobs drain "$j" --region ${GSP_DATAFLOW_REGION}
	done

else
	echo "Cannot find instance.. '${GSP_ETL_INSTANCE_NAME}'"
fi

