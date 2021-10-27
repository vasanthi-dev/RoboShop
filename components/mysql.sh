#!/bin/bash

source components/common.sh

MSPACE=$(cat $0 components/common.sh | grep print | awk -F '"' '{print $2}' | awk '{ print length }'| sort | tail -1)

COMPONENT_NAME=Mysql
COMPONENT=mysql

print "Downloading Repos"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG
stat $?

print "Install MYSQL"
yum remove mariadb-libs -y &>>$LOG && yum install mysql-community-server -y &>>$LOG
stat $?


print "Enable MYSQLD"
systemctl enable mysqld &>>$LOG
stat $?

print "Start MYSQLD"
systemctl start mysqld &>>$LOG
stat $?

DEFAULT_PASSWORD=$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
NEW_PASSWORD="RoboShop@1"

echo 'show databases;' | mysql -uroot -p"${NEW_PASSWORD}" &>>$LOG
if [ $? -ne 0 ]; then
  print "Changing the Default Password"
  echo -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${NEW_PASSWORD}';\nuninstall plugin validate_password;" >/tmp/pass.sql
  mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" </tmp/pass.sql &>>$LOG
  stat $?
fi

DOWNLOAD "/tmp"

print "Load Schema"
cd /tmp/mysql-main
mysql -uroot -p"${NEW_PASSWORD}" <shipping.sql &>>$LOG
stat $?