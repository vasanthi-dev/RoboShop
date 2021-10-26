#!/bin/bash

source components/common.sh
MSPACE=$(cat $0 components/common.sh | grep print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)

COMPONENT_NAME=Catalogue
COMPONENT=catalogue

NODEJS

print "Checking DB Connections from App"
sleep 5
STAT=$(curl -s localhost:8080/health | jq .mongo)
echo status = $STAT
if [ "$STAT" == "true" ]; then
  stat 0
else
  stat 1
fi