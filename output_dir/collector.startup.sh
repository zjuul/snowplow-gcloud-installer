#!/bin/bash
#
# startup script


sudo apt-get update
sudo apt-get -y install default-jre
sudo apt-get -y install unzip
wget https://dl.bintray.com/snowplow/snowplow-generic/snowplow_scala_stream_collector_google_pubsub_0.14.0.zip
gsutil cp gs://sp-storage/collector.config .
unzip snowplow_scala_stream_collector_google_pubsub_0.14.0.zip
java -jar snowplow-stream-collector-google-pubsub-0.14.0.jar --config collector.config &

~                                                                                                                                     
~                                                                                                                                     
~                                                                                 
