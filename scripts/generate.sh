#!/bin/sh

toscafy generate -s vsphere.csarspec.json --refs-only -p -o ./generated/vsphere.csar

toscafy generate -s ubuntu.csarspec.json --refs-only -p -o ./generated/ubuntu.csar

toscafy generate -s ubuntu-on-vsphere.csarspec.json --refs-only -p -o ./generated/ubuntu-on-vsphere.csar
