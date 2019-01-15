#!/bin/bash

. ./0_set_environment.sh
. ./0_functions.sh

if [ ! -z "${GSP_PROJECT_NAME}x" ] ; then
	echo "spinning up instance"
else
	echo "GSP_ env not found. Set first"
	exit 1
fi

# create bq dataset
create_bq_dataset ${GSP_BQ_DATASET_NAME}

# spin up ETL
gcloud compute --project ${GSP_PROJECT_NAME} instances create "${GSP_ETL_INSTANCE_NAME}" \
                 --machine-type "${GSP_ETL_INSTANCE_TYPE}" \
                 --zone "${GSP_REGION}" \
                 --subnet "default" \
                 --maintenance-policy "MIGRATE" \
                 --scopes https://www.googleapis.com/auth/pubsub,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/trace.append,https://www.googleapis.com/auth/devstorage.read_write,https://www.googleapis.com/auth/bigquery,https://www.googleapis.com/auth/compute \
                 --service-account snowplow-manager@snowplow-203709.iam.gserviceaccount.com \
                 --tags "${GSP_ETL_INSTANCE_NAME}" \
                 --image "ubuntu-1804-bionic-v20181120" --image-project "ubuntu-os-cloud" \
                 --boot-disk-size "10" \
                 --boot-disk-type "pd-standard" \
                 --boot-disk-device-name "${GSP_ETL_INSTANCE_NAME}-disk" \
		 --metadata-from-file startup-script=output_dir/etl.startup.sh

echo "Done"


