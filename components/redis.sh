#!/bin/bash

source components/common.sh

MSPACE=$(cat $0 components/common.sh | grep print | awk -F '"' '{print $2}' | awk '{ print length }'| sort | tail -1)

print "Install Redis Repos"
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>$LOG
stat $?

print "Enable Redis"
yum-config-manager --enable remi &>>$LOG
stat $?

print "Install Redis"
yum install redis -y &>>$LOG
stat $?

print "Update Config File"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>$LOG
stat $?

#Update the BindIP from 127.0.0.1 to 0.0.0.0 in config file /etc/redis.conf & /etc/redis/redis.conf

print "Start Redis Database"
systemctl enable redis &>>$LOG && systemctl start redis &>>$LOG