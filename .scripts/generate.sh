#!/bin/sh

for NODE_TYPE in vsphere ubuntu
do
	toscafy generate -c node_types -s node_types/$NODE_TYPE.csarspec.json --refs-only -p -o generated/$NODE_TYPE.csar
done

for TOPOLOGY in ubuntu-on-vsphere
do
  toscafy generate -c topologies -s topologies/$TOPOLOGY.csarspec.json --refs-only -p -o generated/$TOPOLOGY.csar
done
