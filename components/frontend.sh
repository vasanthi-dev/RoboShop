#!/bin/bash

git pull
print(){
  echo -e "\e[32m$1\e[0m"
  echo -e "\n\e[33m=============$1===============\e[0m" >>$LOG
  echo $?>>$LOG
}
LOG=/tmp/roboshop.log
rm -f $LOG

print "Installing Nginx"
yum install nginx -y >>$LOG

print "Enable Nginx"
systemctl enable nginx >>$LOG

print "Start Nginx"
systemctl start nginx >>$LOG


exit
#Let's download the HTDOCS content and deploy under the Nginx path.

curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
#Deploy in Nginx Default Location.

cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-master static README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
#Finally restart the service once to effect the changes.
systemctl restart nginx