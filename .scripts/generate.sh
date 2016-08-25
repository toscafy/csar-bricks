#!/bin/sh

for NAME in all ubuntu-14-04 vsphere-5-5
do
  toscafy generate -c node_types -s node_types/$NAME.csarspec.json --refs-only -p -o generated/$NAME.node_type.csar
done

for NAME in smoketest ubuntu-on-vsphere
do
  toscafy generate -c topologies -s topologies/$NAME.csarspec.json --refs-only -p -o generated/$NAME.topology.csar
done

#
# playground
#

toscafy generate -c playground/wordpress -s playground/wordpress/csarspec.json --refs-only -p -o generated-playground/wordpress.csar
