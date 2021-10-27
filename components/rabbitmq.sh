#!/bin/bash

source components/common.sh

MSPACE=$(cat $0 components/common.sh | grep print | awk -F '"' '{print $2}' | awk '{ print length }'| sort | tail -1)

COMPONENT_NAME=RabbitMQ
COMPONENT=rabbitmq

print "Install Erlang"
yum list installed | grep erlang &>>$LOG
if [ $? -ne 0 ]; then
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>$LOG
fi
stat $?
print "YUM repositories for RabbitMQ"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG
stat $?

print "Install RabbitMQ"
yum install rabbitmq-server -y &>>$LOG
stat $?

print "Start RabbitMQ"
systemctl enable rabbitmq-server &>>$LOG && systemctl start rabbitmq-server &>>$LOG
stat $?

print "Create application user"
rabbitmqctl list_users | grep roboshop &>>$LOG
if [ $? -ne 0 ]; then
rabbitmqctl add_user roboshop roboshop123 &>>$LOG && rabbitmqctl set_user_tags roboshop administrator &>>$LOG && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG
else
  rabbitmqctl set_user_tags roboshop administrator &>>$LOG && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG
fi
stat $?