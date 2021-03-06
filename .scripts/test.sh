#!/bin/sh

git clone https://github.com/jojow/opentosca-dockerfiles.git dockerfiles

#cp generated/*.topology.csar dockerfiles/runner/csars/
cp generated/$CSAR.csar dockerfiles/runner/csars/

cd dockerfiles

docker-compose -f docker-compose-runner.yml pull
docker-compose -f docker-compose-runner.yml build
docker-compose -f docker-compose-runner.yml up pre-runner

export RUNNER_CONTEXT_DIR=$(pwd)/../runners/$RUNNER
docker-compose -f docker-compose-runner.yml up runner

docker-compose -f docker-compose-runner.yml up post-runner
#docker-compose -f docker-compose-runner.yml logs
docker-compose -f docker-compose-runner.yml down
