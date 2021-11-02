#!/bin/bash

CREATE(){
  COUNT=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" | jq ".Reservations[].Instances[].PrivateIpAddress" | grep -v null | wc -l)

  if [ $COUNT -eq 0 ]
   then
    # shellcheck disable=SC1072
    aws ec2 run-instances --launch-template LaunchTemplateId=lt-099eb0b79a90eeba3,Version=2 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]" "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=$1}]" | jq &>>/dev/null
  else
    echo -e  "\e[31mInstance already exists\e[0m"
  fi
  sleep 5
  IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" | jq ".Reservations[].Instances[].PrivateIpAddress" | grep -v null | xargs )
  #xargs is used to remove double quotes
  sed -e "s/DNSNAME/$1.roboshop.internal/" -e "s/IPADDRESS/${IP}/" record.json >/tmp/record.json

  aws route53 change-resource-record-sets --hosted-zone-id Z009674929X25UC88DYV9 --change-batch file:///tmp/record.json
}

if [ $1 == "all" ]; then
  ALL=(frontend user mongodb redis catalogue cart shipping payment rabbitmq mysql)
  for component in ${ALL[*]}; do
  echo "Creating Instance - $component"
  CREATE $component
  done
else
  CREATE $1
  fi
