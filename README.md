# netlogo-docker
Project to create docker image with Netlogo and R extension. Entrypoint is netlogo-headless.sh

## Example for sample-data is:
sudo docker run --rm -v /home/user/netlogo-docker/sample-data:/netlogo -w /netlogo -it netlogo-r-headless --model /netlogo/NagsHead_bayes_storm.nlogo --experiment Nags_bayes --spreadsheet spreadsht.csv
