#!/bin/bash

source components/common.sh

MSPACE=$(cat $0 components/common.sh | grep print | awk -F '"' '{print $2}' | awk '{ print length }'| sort | tail -1)

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

print "Copy Files to Nginx Path"
mv /tmp/frontend-main/static/* /usr/share/nginx/html/. &>>$LOG
stat $?

print "Copy Nginx Roboshop Config File"
cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>LOG
stat $?

print "Update Nginx Config file"
sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/' -e '/shipping/ s/localhost/shipping.roboshop.internal/' -e '/payment/ s/localhost/payment.roboshop.internal/' /etc/nginx/default.d/roboshop.conf &>>LOG
stat $?

print "Enable Nginx"
systemctl enable nginx &>>$LOG
stat $?

print "Restart Nginx"
systemctl restart nginx &>>$LOG
stat $?