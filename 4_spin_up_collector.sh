#!/bin/bash

if [ -v GSP_PROJECT_NAME ] ; then
	echo "spinning up instance"
else
	echo "GSP_ env not found. Set first"
	exit 1
fi


gcloud compute --project ${GSP_PROJECT_NAME} instances create "${GSP_COLLECTOR_INSTANCE_NAME}" \
                 --machine-type "${GSP_COLLECTOR_INSTANCE_TYPE}" \
                 --zone "${GSP_REGION}" \
                 --subnet "default" \
                 --maintenance-policy "MIGRATE" \
                 --scopes https://www.googleapis.com/auth/pubsub,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/trace.append,https://www.googleapis.com/auth/devstorage.read_only \
                 --service-account snowplow-manager@snowplow-203709.iam.gserviceaccount.com \
                 --tags "${GSP_COLLECTOR_INSTANCE_NAME}" \
                 --image "ubuntu-1804-bionic-v20181120" --image-project "ubuntu-os-cloud" \
                 --boot-disk-size "10" \
                 --boot-disk-type "pd-standard" \
                 --boot-disk-device-name "instance-2"

echo "Done. Now the firewall rule"

gcloud compute --project ${GSP_PROJECT_NAME} firewall-rules create "collectors-allow-web" \
                 --allow tcp:${GSP_COLLECTOR_PORT} \
                 --network "default" \
                 --source-ranges "0.0.0.0/0" \
                 --target-tags "${GSP_COLLECTOR_INSTANCE_NAME}"



echo "Done"


