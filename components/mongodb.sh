#!/bin/bash

source components/common.sh

print "Downloading Repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG
stat $?

print "Install MongoDB"
yum install -y mongodb-org &>>$Log
stat $?

print "Update MongoDB Config"
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOG
stat $?

print "Enable MongoDB"
systemctl enable mongod &>>$LOG
stat $?

print "Restart MongoDB"
systemctl restart mongod &>>$LOG
stat $?

print "Download Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG
stat $?

print "Extract Schema"
unzip -o -d /tmp mongodb.zip &>>$LOG
stat $?

print "Load Schema"
cd /tmp/mongodb-main
mongo < catalogue.js &>>$LOG
mongo < users.js &>>$LOG



