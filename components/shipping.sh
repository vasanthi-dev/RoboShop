#!/bin/bash

source components/common.sh

MSPACE=$(cat $0 components/common.sh | grep print | awk -F '"' '{print $2}' | awk '{ print length }'| sort | tail -1)

COMPONENT_NAME=Shipping
COMPONENT=shipping

MAVEN

print "Checking DB Connection From App"
sleep 15
curl -s http://localhost:8080/health &>>$LOG
stat $?

