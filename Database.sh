#!/bin/bash

# This is only for AWS

yum install -y mariadb*
systemctl start mariadb
systemctl enable mariadb

mysql_secure_installation

ip=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

echo "Enter the name of Database ="
read db

echo "Enter the name of user that is to be created ="
read us

echo "Enter the password for the user ="
read ps

mysql -u root -p << EOFMYSQL

create database $db;
create user $us@"$ip" identified by "$ps";
grant all privileges on $db.* to $us@"$ip";
flush privileges;

EOFMYSQL
