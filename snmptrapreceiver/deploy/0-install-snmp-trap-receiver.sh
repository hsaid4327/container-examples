#!/bin/bash

# Create namespace and make sure it's active
oc create -f 1-namespace.yaml
oc project snmp-trap-receiver

# Create DC
oc create -f 2-deploymentconfig.yaml

# Create NodePort service
oc create -f 3-snmp-service.yaml

# Create and Initiate build
oc new-build https://github.com/ekrunch/container-examples.git --context-dir='/snmptrapreceiver' --name='snmp-trap-receiver'
