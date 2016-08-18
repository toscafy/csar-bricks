#!/bin/sh

git clone --recursive https://github.com/jojow/opentosca-dockerfiles.git dockerfiles

cp generated/*.topology.csar dockerfiles/runner/csars/

cd dockerfiles

docker-compose -f docker-compose-runner.yml pull
docker-compose -f docker-compose-runner.yml build

docker-compose -f docker-compose-runner.yml up pre-runner
docker-compose -f docker-compose-runner.yml up runner
docker-compose -f docker-compose-runner.yml up post-runner

docker-compose -f docker-compose-runner.yml logs
docker-compose -f docker-compose-runner.yml down
