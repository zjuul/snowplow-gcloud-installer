
# config file for Google Snow Plow setup scripts.
# prefix is GSP, for easy grepping. Source with . ./0-set-environment.sh
#

# directory of your scripts and files
# needs 2 dirs: ./templates and ./outpuyt-dir
export GSP_ROOTDIR=~/git/snowplow-google

# GCE project name and credential file
export GSP_PROJECT_NAME="snowplow-203709"
export GSP_KEYFILE=${GSP_ROOTDIR}/credentials.json

# region - all 
export GSP_REGION="europe-west3-c"

######################
# storage bucket
export GSP_STORAGE_BUCKET="sp-storage"


######################
# collector
export GSP_COLLECTOR_INSTANCE_NAME="sp-collector"
# f1-micro g1-small n1-standard-1
export GSP_COLLECTOR_INSTANCE_TYPE="n1-standard-1"


# config
export GSP_COLLECTOR_VERSION="0.14.0"
export GSP_COLLECTOR_PORT="8080"
export GSP_DOMAIN_LISTEN='[ "*" , "127.0.0.1" ]'


######################
# pubsub

# collector sinks
export GSP_PUBSUB_GOOD="good"
export GSP_PUBSUB_BAD="bad"

# shredded sinks
export GSP_PUBSUB_GOOD_SHRED="sp-shred-good"
export GSP_PUBSUB_BAD_SHRED="sp-shred-bad"

# just for tests
export GSP_PUBSUB_GOOD_SUB="test-subscription"





