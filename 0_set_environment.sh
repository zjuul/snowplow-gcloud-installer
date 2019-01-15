
# config file for Google Snow Plow setup scripts.
# prefix is GSP, for easy grepping. Source with . ./0-set-environment.sh
#

# change this:
export GSP_RANDOM_UUID="04c32a70-532e-4358-ab78-d4a597dbf982"

# directory of your scripts and files
# needs 2 dirs: ./templates and ./outpuyt-dir
export GSP_ROOTDIR=~/git/snowplow-google

# GCE project name and credential file
export GSP_PROJECT_NAME="snowplow-203709"
export GSP_KEYFILE=${GSP_ROOTDIR}/credentials.json

export GSP_SERVICE_ACCOUNT=$(grep client_email ${GSP_KEYFILE} | cut -d\" -f4)


# region - all 
export GSP_REGION="europe-west3-c"

######################
# storage buckets

# main storage. Script also creates a bucket with -tmp appended
export GSP_STORAGE_BUCKET="sp-storage"

######################
# iglu resolve with google?
# y = "_google"
# n = ""
export GSP_RESOLVE_GOOGLE="_google"
export GSP_RESOLVE_GOOGLE=""

######################
# collector instance
export GSP_COLLECTOR_INSTANCE_NAME="sp-collector"
# f1-micro g1-small n1-standard-1
export GSP_COLLECTOR_INSTANCE_TYPE="n1-standard-1"


# config
export GSP_COLLECTOR_VERSION="0.14.0"
export GSP_COLLECTOR_PORT="8080"
export GSP_DOMAIN_LISTEN='[ "*" , "127.0.0.1" ]'


######################
# ETL instance
export GSP_ETL_INSTANCE_NAME="sp-etl"
# f1-micro g1-small n1-standard-1
export GSP_ETL_INSTANCE_TYPE="n1-standard-1"

# config
export GSP_ETL_VERSION="0.1.0"
export GSP_ETL_BQ_VERSION="0.1.0"
export GSP_DOMAIN_LISTEN='[ "*" , "127.0.0.1" ]'

######################
# pubsub

# subscriptions will append -sub to the sink

# collector sinks
export GSP_PUBSUB_GOOD="sp-coll-good"
export GSP_PUBSUB_BAD="sp-coll-bad"

# enriched
export GSP_PUBSUB_GOOD_ENRICHED="sp-enriched-good"
export GSP_PUBSUB_BAD_ENRICHED="sp-enriched-bad"

# BQ sinks
export GSP_PUBSUB_BQ_BAD="bq-bad-rows"
export GSP_PUBSUB_BQ_FAILED="bq-failed-inserts"
export GSP_PUBSUB_BQ_TYPES="bq-types"

# just for tests
export GSP_PUBSUB_GOOD_SUB="test-sub"

######################
# bigquery

export GSP_BQ_DATASET_NAME="snowplow_dataset"
export GSP_BQ_DATA_LOCATION="EU"

