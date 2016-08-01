#!/bin/bash

: ${WINERY_ENDPOINT:=http://winery.opentosca.org/winery/}

for NAME in all_node_types ubuntu-on-vsphere
do
  curl -L -F "file=@generated/$NAME.csar" $WINERY_ENDPOINT
done
