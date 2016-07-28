#!/bin/sh

toscafy generate -s node_types/vsphere.csarspec.json --refs-only -p -o generated/vsphere.csar

toscafy generate -s node_types/ubuntu.csarspec.json --refs-only -p -o generated/ubuntu.csar

toscafy generate -s topologies/ubuntu-on-vsphere.csarspec.json --refs-only -p -o generated/ubuntu-on-vsphere.csar
