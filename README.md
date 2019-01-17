# Snowplow Google Cloud install script

This is a set of scripts the installs Snowplow analytics on the Google Cloud Platform.
It supports various configuration parameters.

Based on: https://www.simoahava.com/analytics/install-snowplow-on-the-google-cloud-platform/
Building upon the great work by the Snowplow team: https://snowplowanalytics.com/

## Getting Started

Clone this repository, and open a bash shell (tested on Mac and Ubuntu Linus)
Then, edit the `0_set_environment.sh` file. This contains all the naming conventions etc.

The following scripts can be run in order.

BUT!! it will probably not work completely. Or you might not need all functionality.
Currently, these scripts are not interactive, and just execute a lot of chunks in 1 go.

Best results are obtained by actually _reading_ the scripts (always a good idea) and decide which bits you need.

```
1_init_gcloud.sh
2_create_pubsub_topics.sh
3_prepare_files_and_storage.sh
4_spin_up_collector.sh
4b_load_balance_collector.sh
5_spin_up_etl.sh
```

Consider it a recipe, not a meal.

### Prerequisites

A solid understanding of shell-scripting, cutting-pasting, and KNOWING what you're doing.
This is not a polished product. It works for me (most of the time ;-))

You will need:

The latest `gcloud` command-line tools, obviously.

You have set up a GCP project with billing enabled. Also, make sure you have the needed services in this project enabled.

You also need a service account, and a `credentials.json` somewhere, so the project can be set up using this credentials.


## Support & Contributing

If you want to contribute to this project, please contact me. There's a _lot_ that can be improved and added.
If you find bugs or if you want improvements: Thank you! Raise an issue and I will look at it, and fix it if I can.

If you need help setting up Snowplow: consider buying a managed pipeline from Snowplow LLC, the creators.
If your pipeline crashes, your machines go down, things stop working: here is the place to go: https://discourse.snowplowanalytics.com/

Want to chat with me? Just send me a tweet https://twitter.com/zjuul

## License

This project is licensed under the MIT license. See LICENSE.txt for details

## Acknowledgments

* Simo Ahava - his blogpost inspired me to do this
* The Snowplow Analytics team - they're awesome
* The fabulous #measure community 
* All the question-askers and question-answerers on Stackoverflow



