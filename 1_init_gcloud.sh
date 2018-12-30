#!/bin/bash

if [ ! -z "${GSP_PROJECT_NAME}x" ] ; then
	echo "Initialize gcloud..."
else
	echo "GSP_ env not found. Set first"
	exit 1
fi

gcloud config set project $GSP_PROJECT_NAME
gcloud auth activate-service-account --key-file=$GSP_KEYFILE
gcloud config set compute/region "$GSP_REGION"
