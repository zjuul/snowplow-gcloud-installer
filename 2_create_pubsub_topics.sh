#!/bin/bash

if [ -v GSP_PROJECT_NAME ] ; then
	echo "creating pubsub topics..."
else
	echo "GSP_ env not found. Set first"
	exit 1
fi


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

create_topic ${GSP_PUBSUB_GOOD}
create_topic ${GSP_PUBSUB_BAD}

# test listener on sp-test-good

gcloud pubsub subscriptions create ${GSP_PUBSUB_GOOD_SUB} --topic ${GSP_PUBSUB_GOOD}

echo "Done"


