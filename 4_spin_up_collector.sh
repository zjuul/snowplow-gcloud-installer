#!/bin/bash

. ./0_set_environment.sh
. ./0_functions.sh

if [ ! -z "${GSP_PROJECT_NAME}x" ] ; then
	echo "spinning up instance"
else
	echo "GSP_ env not found. Set first"
	exit 1
fi


gcloud compute --project ${GSP_PROJECT_NAME} instance-templates create "${GSP_COLLECTOR_INSTANCE_NAME}" \
                 --machine-type "${GSP_COLLECTOR_INSTANCE_TYPE}" \
		 --network=projects/${GSP_PROJECT_NAME}/global/networks/default \
                 --network-tier=PREMIUM \
		 --region ${GSP_REGION%??} \
                 --subnet "default" \
                 --maintenance-policy "MIGRATE" \
                 --scopes https://www.googleapis.com/auth/pubsub,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/trace.append,https://www.googleapis.com/auth/devstorage.read_only \
                 --service-account ${GSP_SERVICE_ACCOUNT} \
                 --tags "${GSP_COLLECTOR_INSTANCE_NAME}" \
                 --image "ubuntu-1804-bionic-v20181120" --image-project "ubuntu-os-cloud" \
                 --boot-disk-size "10" \
                 --boot-disk-type "pd-standard" \
                 --boot-disk-device-name "${GSP_COLLECTOR_INSTANCE_NAME}-disk" \
		 --metadata-from-file startup-script=output_dir/collector.startup.sh

echo "Done. Now the firewall rule"

gcloud compute --project ${GSP_PROJECT_NAME} firewall-rules create "collectors-allow-web" \
                 --allow tcp:${GSP_COLLECTOR_PORT} \
                 --network "default" \
                 --source-ranges "0.0.0.0/0" \
                 --target-tags "${GSP_COLLECTOR_INSTANCE_NAME}"

echo "Done. Now creating instance group (managed)"

gcloud beta compute --project=${GSP_PROJECT_NAME} \
		instance-groups managed create ${GSP_COLLECTOR_INSTANCE_GROUP_NAME} \
		--base-instance-name=${GSP_COLLECTOR_INSTANCE_GROUP_NAME} \
		--template=${GSP_COLLECTOR_INSTANCE_NAME} \
		--size=1 --zone=${GSP_REGION}
		
echo "Done. Now adding collector"


gcloud compute --project=${GSP_PROJECT_NAME} \
		instance-groups managed set-autoscaling ${GSP_COLLECTOR_INSTANCE_GROUP_NAME} \
		--zone=${GSP_REGION} \
		--cool-down-period "300" \
		--max-num-replicas "2" --min-num-replicas "1" \
		--target-cpu-utilization "0.9"

echo "Done"


