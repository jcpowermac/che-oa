#!/bin/bash
TOKEN_FILE=${HOME}/service-token.txt
CLUSTER='https://api.starter-us-east-2.openshift.com/'
TOKEN=`cat ${TOKEN_FILE}`
PODSHELL='/bin/bash'

set -x

oc login --token ${TOKEN} ${CLUSTER}
PODNAME=`oc get pod -l  che.original_name=ws -o jsonpath='{.items[0].metadata.name}'`

oc rsh -c dev -t --shell=${PODSHELL} ${PODMAN} 
