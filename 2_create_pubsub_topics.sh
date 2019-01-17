#!/bin/bash

if [ ! -z "${GSP_PROJECT_NAME}x" ] ; then
	echo "creating pubsub topics..."
else
	echo "GSP_ env not found. Set first"
	exit 1
fi

. ./0_functions.sh

create_topic ${GSP_PUBSUB_GOOD}
create_topic ${GSP_PUBSUB_BAD}
create_topic ${GSP_PUBSUB_GOOD_ENRICHED}
create_topic ${GSP_PUBSUB_BAD_ENRICHED}

create_topic ${GSP_PUBSUB_BQ_BAD}
create_topic ${GSP_PUBSUB_BQ_FAILED}
create_topic ${GSP_PUBSUB_BQ_TYPES}


gcloud pubsub subscriptions create ${GSP_PUBSUB_GOOD}-sub          --topic ${GSP_PUBSUB_GOOD}
gcloud pubsub subscriptions create ${GSP_PUBSUB_GOOD_ENRICHED}-sub --topic ${GSP_PUBSUB_GOOD_ENRICHED}

# optional - for debugging purposes
#gcloud pubsub subscriptions create ${GSP_PUBSUB_BQ_TYPES}-sub      --topic ${GSP_PUBSUB_BQ_TYPES}
#gcloud pubsub subscriptions create ${GSP_PUBSUB_BQ_FAILED}-sub     --topic ${GSP_PUBSUB_BQ_FAILED}
#gcloud pubsub subscriptions create ${GSP_PUBSUB_BQ_BAD}-sub        --topic ${GSP_PUBSUB_BQ_BAD}
	
echo "Done"

