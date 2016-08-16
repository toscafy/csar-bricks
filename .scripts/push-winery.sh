#!/bin/bash

: ${WINERY_ENDPOINT:=http://winery.opentosca.org/winery}

for NAME in all ubuntu-14-04 vsphere-5-5 ubuntu-on-vsphere
do
  curl -L -F "file=@generated/$NAME.csar" $WINERY_ENDPOINT
done
