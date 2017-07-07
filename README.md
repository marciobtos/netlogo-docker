# netlogo-docker
Project to create docker image with Netlogo and R extension. Entrypoint is net logo-headless.sh

## Example for sample-data is:
sudo docker run --rm -v /home/lisa/netlogo:/netlogo -w /netlogo -it lisastillwell/netlogo-r-headless --model /netlogo/NagsHead_bayes_storm.nlogo --experiment Nags_bayes --spreadsheet spreadsht.csv
