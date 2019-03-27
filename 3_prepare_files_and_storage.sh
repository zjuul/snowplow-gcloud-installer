#!/bin/bash

. ./0_set_environment.sh
. ./0_functions.sh

if [ ! -z "${GSP_PROJECT_NAME}x" ] ; then
	echo "creating collector + etl configs..."
else
	echo "GSP_ env not found. Set first"
	exit 1
fi


# config template
create_config_file collector.config.template collector.config
create_config_file bigquery_config.json.template bigquery_config.json

# place in bucket

create_storage ${GSP_STORAGE_BUCKET} || exit 1
gsutil cp output_dir/collector.config gs://$GSP_STORAGE_BUCKET

create_storage ${GSP_STORAGE_BUCKET}-tmp
gsutil cp templates/iglu_resolver${GSP_RESOLVE_GOOGLE}.json gs://${GSP_STORAGE_BUCKET}-tmp/iglu_resolver.json
gsutil cp output_dir/bigquery_config.json gs://${GSP_STORAGE_BUCKET}-tmp/bigquery_config.json


# startup scripts
create_config_file collector.startup.template collector.startup.sh
create_config_file etl.startup.template etl.startup.sh

# enrichments
gsutil cp enrichments/*.json gs://${GSP_STORAGE_BUCKET}/enrichments/

echo "Done"


