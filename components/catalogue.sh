#!/bin/bash

source components/common.sh

print "Installing NodeJS"
yum install nodejs make gcc-c++ -y &>>$LOG
stat $?

print "Add RoboShop User"
id roboshop &>>$LOG
if [ $? -eq 0 ]; then
  echo -e "\e[31mRoboShop User Already Exists\e[0m" &>>$LOG
  else
  useradd roboshop &>>$LOG
fi
stat $?

print "Download Catalogue"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
stat $?

print "Remove Old Content"
rm -rf /home/roboshop/catalogue &>>$LOG
stat $?

print "Extract Catalogue Archive"
unzip -o -d /home/roboshop /tmp/catalogue.zip &>>$LOG
stat $?

print "Copy Content"
mv /home/roboshop/catalogue-main /home/roboshop/catalogue &>>$LOG
stat $?

print "Install NodeJS Dependencies"
cd /home/roboshop/catalogue
npm install --unsafe-perm &>>$LOG
stat $?

print "Fix App Permissions"
chown -R roboshop:roboshop /home/roboshop
stat $?

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue