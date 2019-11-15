# netlogo-docker
Project to create docker image with Netlogo and R extension. Entrypoint is netlogo-headless.sh

## Example for sample-data is:
docker run --rm -v /Users/marciookimoto/Documents/netlogo-docker-master/netlogo-docker-marcio/c2_approach_change/:/netlogo -w /netlogo -it netlogo-docker-marcio --model /netlogo/swarm-gap-loop-limite.nlogo --experiment experiment --spreadsheet sp.csv
