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

exit
$ cd /home/roboshop
$ unzip /tmp/catalogue.zip
$ mv catalogue-main catalogue
$ cd /home/roboshop/catalogue
$ npm install
NOTE: We need to update the IP address of MONGODB Server in systemd.service file
Now, lets set up the service with systemctl.

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue