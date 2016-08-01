#!/bin/sh

for NAME in all_node_types
do
	toscafy generate -c node_types -s node_types/$NAME.csarspec.json --refs-only -p -o generated/$NAME.csar
done

for NAME in ubuntu-on-vsphere
do
  toscafy generate -c topologies -s topologies/$NAME.csarspec.json --refs-only -p -o generated/$NAME.csar
done
