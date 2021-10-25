#!/bin/bash

source components/common.sh

print "Installing Nginx"
yum install nginx -y &>>$LOG
stat $?

print "Download html pages"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG
stat $?

print "Remove old html pages"
rm -rf /usr/share/nginx/html/* &>>$LOG
stat $?

print "Extract Frontend Archive"
unzip -o -d /tmp /tmp/frontend.zip &>>$LOG
stat $?

print "Copy Files to Nginx Path "
mv /tmp/frontend-main/static/* /usr/share/nginx/html/. &>>$LOG
stat $?

print "Copy Nginx Roboshop Config File"
cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>LOG
stat $?

print "Enable Nginx"
systemctl enable nginx &>>$LOG
stat $?

print "Restart Nginx"
systemctl restart nginx &>>$LOG
stat $?