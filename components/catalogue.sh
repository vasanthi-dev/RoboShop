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
chown -R roboshop:roboshop /home/roboshop &>>$LOG
stat $?

print "Update DNS records in systemd config"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>$LOG
stat $?

print "Copy systemD file"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG
stat $?

print "Start Catalogue Service"
systemctl daemon-reload && systemctl restart catalogue && systemctl enable catalogue &>>$LOG
stat $?

print "Checking DB Connections from App"
STAT=$(curl -s localhost:8080/health | jq .mongo)
echo status = $STAT
if [ "$STAT" == "true" ]; then
  stat 0
else
  stat 1
fi