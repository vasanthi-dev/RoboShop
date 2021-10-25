#!/bin/bash

source components/common.sh

print "Installing Nginx"
yum install nginx -y >>$LOG
stat $?

print "Enable Nginx"
systemctl enable nginx >>$LOG
stat $?

print "Start Nginx"
systemctl start nginx >>$LOG
stat $?

print "Download content"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
stat $?

print "Change Directories"
cd /usr/share/nginx/html
stat $?

exit
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-master static README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
#Finally restart the service once to effect the changes.
systemctl restart nginx