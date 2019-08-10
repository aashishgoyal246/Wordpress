#!/bin/bash

# Wordpress installation script for aws ec2

# In this firewall is not added and if use linux local machine then add firewall service and port

yum install -y httpd* vim wget mariadb
systemctl start httpd
systemctl enable httpd

wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz

setenforce 0   # Setting SElinux to permissive

# Fetching IP

ip=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

# For Wordpress

mkdir /var/www/html/wordpress
cp -r wordpress/* /var/www/html/wordpress
chown -R apache /var/www
chgrp -R apache /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;

chkconfig httpd on

# Apache configuration for Wordpress

cat >> /etc/httpd/conf.d/1.conf << EOF

<virtualhost $ip:80>
documentroot /var/www/html/wordpress
servername $ip
</virtualhost>

EOF

# Installing PHP

yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install -y yum-utils
yum-config-manager --enable remi-php72
yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo

systemctl restart httpd

