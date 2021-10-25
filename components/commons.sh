#!/bin/bash

echo -e "\e[1;32m=============GIT PULL=============\e[0m"
git pull
print(){
  echo -n -e "\e[1m$1\e[0m .... "
  echo -e "\n\e[33m=============$1===============\e[0m" >>$LOG
}
stat(){
   if [ $1 -eq 0 ]; then
    echo -e "\e[1;32mSUCCESS\e[0m"
  else
    echo -e "\e[1;31mFAILURE\e[0m"
    echo -e "\e[1;31mScript Failed and check the detailed log in $LOG file\e[0m"
    exit 1
  fi
}
LOG=/tmp/roboshop.log
rm -f $LOG