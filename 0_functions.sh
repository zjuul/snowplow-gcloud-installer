#!/bin/bash

# pubsub functions


TOPICS=$( gcloud pubsub topics list )

if [ $? -ne 0 ] ; then
        echo "could not get topics list"
        exit 1
fi
create_topic() {
        if echo $TOPICS | grep -q projects/${GSP_PROJECT_NAME}/topics/$1 ; then
                echo $1 already exists.. skip
        else
                gcloud pubsub topics create $1
        fi
}

# creating files

# infile, outfile - note match order! BLA_BLA before BLA :-)
create_config_file() {
	mkdir -p output_dir
        if [ -f templates/$1 ] ; then
                cat templates/$1 | \
                sed -e "s/GSP_PUBSUB_GOOD_ENRICHED/${GSP_PUBSUB_GOOD_ENRICHED}/" \
                    -e "s/GSP_PUBSUB_GOOD/${GSP_PUBSUB_GOOD}/" \
                    -e "s/GSP_PUBSUB_BAD_ENRICHED/${GSP_PUBSUB_BAD_ENRICHED}/" \
                    -e "s/GSP_PUBSUB_BAD/${GSP_PUBSUB_BAD}/" \
                    -e "s/GSP_DOMAIN_LISTEN/${GSP_DOMAIN_LISTEN}/" \
                    -e "s/GSP_PROJECT_NAME/${GSP_PROJECT_NAME}/" \
                    -e "s/GSP_COLLECTOR_PORT/${GSP_COLLECTOR_PORT}/" \
                    -e "s/GSP_COLLECTOR_VERSION/${GSP_COLLECTOR_VERSION}/" \
                    -e "s/GSP_STORAGE_BUCKET/${GSP_STORAGE_BUCKET}/" \
                    -e "s/GSP_RANDOM_UUID/${GSP_RANDOM_UUID}/" \
                    -e "s/GSP_BQ_DATASET_NAME/${GSP_BQ_DATASET_NAME}/" \
                    -e "s/GSP_PUBSUB_BQ_TYPES/${GSP_PUBSUB_BQ_TYPES}/" \
                    -e "s/GSP_PUBSUB_BQ_BAD/${GSP_PUBSUB_BQ_BAD}/" \
                    -e "s/GSP_PUBSUB_BQ_FAILED/${GSP_PUBSUB_BQ_FAILED}/" \
                    -e "s/GSP_RANDOM_UUID/${GSP_RANDOM_UUID}/" \
                    -e "s/GSP_DATAFLOW_REGION/${GSP_DATAFLOW_REGION}/" \
                    -e "s/GSP_REGION/${GSP_REGION}/" \
                > output_dir/$2
        else
                echo "template not found: $1"
                exit 1
        fi
}

# buckets

# in: bucketname
create_storage() {
        if gsutil ls | grep -q gs://$1/ ; then
                echo $1 already exists.. skip
        else
                gsutil mb -c regional -l ${GSP_REGION%??} gs://$1
        fi
}

# bigquery dataset
# in: dataset name
create_bq_dataset() {
        if bq ls | grep -q $1 ; then
                echo $1 already exists.. skip
        else
                bq mk -d --data_location=${GSP_BQ_DATA_LOCATION} $1
        fi
}


# IPv4
create_ip() {
	if gcloud compute --project ${GSP_PROJECT_NAME} addresses list | grep -q -- ${GSP_COLLECTOR_NAME}-ip ; then
		echo "I have an address.." >/dev/stderr
	else 
		gcloud compute --project ${GSP_PROJECT_NAME} addresses create ${GSP_COLLECTOR_NAME}-ip \
			--global \
			--ip-version IPV4
	fi
	
	echo $(gcloud compute --project ${GSP_PROJECT_NAME} addresses list | grep -- ${GSP_COLLECTOR_NAME}-ip | awk '{print $2}')
}
