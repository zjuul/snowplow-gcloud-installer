#!/bin/bash

if [ -v GSP_PROJECT_NAME ] ; then
	echo "creating collector config..."
else
	echo "GSP_ env not found. Set first"
	exit 1
fi


# infile, outfile
create_config_file() {
	if [ -f templates/$1 ] ; then
		cat templates/$1 | \
		sed -e "s/PUBSUB_GOOD/${GSP_PUBSUB_GOOD}/" \
		    -e "s/PUBSUB_BAD/${GSP_PUBSUB_BAD}/" \
		    -e "s/DOMAIN_LISTEN/${GSP_DOMAIN_LISTEN}/" \
		    -e "s/PROJECT_NAME/${GSP_PROJECT_NAME}/" \
		    -e "s/COLLECTOR_PORT/${GSP_COLLECTOR_PORT}/" \
		    -e "s/COLLECTOR_VERSION/${GSP_COLLECTOR_VERSION}/" \
		    -e "s/STORAGE_BUCKET/${GSP_STORAGE_BUCKET}/" \
		> output_dir/$2
	else
		echo "template not found"
		exit 1
	fi
}

# bucketname 
create_storage() {
	if gsutil ls | grep -q gs://${GSP_STORAGE_BUCKET}/ ; then
		echo $1 already exists.. skip
	else
		gsutil mb -c regional -l ${GSP_REGION%??} gs://$GSP_STORAGE_BUCKET
	fi
}


# config template
create_config_file collector.config.template collector.config

# place in bucket
gsutil cp output_dir/collector.config gs://$GSP_STORAGE_BUCKET

# startup script
create_config_file collector.startup.template collector.startup.sh



echo "Done"


