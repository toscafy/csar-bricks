#!/bin/bash

: ${WINERY_ENDPOINT:=http://winery.opentosca.org/winery}

for CSAR in generated/*
do
  curl -L -F "file=@$CSAR" $WINERY_ENDPOINT
done
