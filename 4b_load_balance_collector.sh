#!/bin/bash

. ./0_set_environment.sh
. ./0_functions.sh

if [ ! -z "${GSP_PROJECT_NAME}x" ] ; then
	echo "Creating load balancing and DNS"
else
	echo "GSP_ env not found. Set first"
	exit 1
fi


# load balancing requires..


echo ....... health check

gcloud compute --project ${GSP_PROJECT_NAME} health-checks create http ${GSP_COLLECTOR_HEALTH} \
        --check-interval=300s --port=${GSP_COLLECTOR_PORT} \
        --request-path=/health --unhealthy-threshold=3


echo ....... create backend-service

gcloud compute --project ${GSP_PROJECT_NAME} --region ${GSP_REGION%??} \
	instance-groups set-named-ports ${GSP_COLLECTOR_INSTANCE_NAME} \
	--named-ports http-port:80 
	
gcloud compute --project ${GSP_PROJECT_NAME} backend-services create ${GSP_COLLECTOR_INSTANCE_NAME}-backend-service \
	--health-checks ${GSP_COLLECTOR_HEALTH} \
	--protocol=HTTP \
	--port-name http-port \
	--global


echo ....... adding backend-service to instance

gcloud compute --project ${GSP_PROJECT_NAME} --region ${GSP_REGION%??} \
	compute backend-services add-backend ${GSP_COLLECTOR_INSTANCE_NAME}-backend-service \
	--instance-group ${GSP_COLLECTOR_INSTANCE_NAME}

echo ....... url map

gcloud compute --project ${GSP_PROJECT_NAME} --region ${GSP_REGION%??} \
	url-maps create ${GSP_COLLECTOR_INSTANCE_NAME}-url-map \
	--default-service ${GSP_COLLECTOR_INSTANCE_NAME}-backend-service

gcloud compute --project ${GSP_PROJECT_NAME} --region ${GSP_REGION%??} \
	url-maps add-path-matcher ${GSP_COLLECTOR_INSTANCE_NAME}-url-map \
	--path-matcher-name=${GSP_COLLECTOR_INSTANCE_NAME}-path-matcher \
	--new-hosts ${GSP_TRACKER_HOST} \
	--default-service ${GSP_COLLECTOR_INSTANCE_NAME}-backend-service


echo ....... ssl cert (managed by google)

gcloud compute --project ${GSP_PROJECT_NAME} \
	ssl-certificates create ${GSP_COLLECTOR_INSTANCE_NAME}-certificate \
	--domains ${GSP_TRACKER_HOST}

echo ....... ssl-proxy

gcloud compute --project ${GSP_PROJECT_NAME} \
	target-https-proxies create ${GSP_COLLECTOR_INSTANCE_NAME}-https-proxy \
	--url-map=${GSP_COLLECTOR_INSTANCE_NAME}-url-map \
	--ssl-certificate ${GSP_COLLECTOR_INSTANCE_NAME}-certificate

echo ....... IP address..

# get (or create) ip (from 0_functions.sh file ) - or create one
export MY_IP=$(create_ip)

echo ....... forwarding rule

gcloud compute --project ${GSP_PROJECT_NAME} \
	forwarding-rules create ${GSP_COLLECTOR_INSTANCE_NAME}-forwarding-rule \
	--address ${MY_IP} \
	--global --ip-protocol TCP --port-range 443 \
	--target-https-proxy=${GSP_COLLECTOR_INSTANCE_NAME}-https-proxy


echo ....... DNS - not executing.. do it yourself (or paste, if domain is goole hosted)

echo gcloud dns --project=${GSP_PROJECT_NAME} record-sets transaction start --zone=datadatadata
echo gcloud dns --project=${GSP_PROJECT_NAME} record-sets transaction add ${MY_IP} \\
echo	--name=${GSP_TRACKER_HOST}. --ttl=300 --type=A --zone=datadatadata
echo gcloud dns --project=${GSP_PROJECT_NAME} record-sets transaction execute --zone=datadatadata

echo "Done"

