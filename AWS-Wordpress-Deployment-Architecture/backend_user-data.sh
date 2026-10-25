#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt update -y

apt install -y mysql-server

systemctl enable mysql
systemctl start mysql

sed -i 's/^[[:space:]]*bind-address[[:space:]]*=.*/bind-address = 0.0.0.0/' \
  /etc/mysql/mysql.conf.d/mysqld.cnf

  
systemctl restart mysql

DB_NAME="wordpress"
DB_USER="wp_user"
DB_PASS="Password@123"

mysql -e "CREATE DATABASE ${DB_NAME};"
mysql -e "CREATE USER '${DB_USER}'@'10.0.%' IDENTIFIED BY '${DB_PASS}';"
# mysql -e "CREATE USER '${DB_USER}'@'10.0.%' IDENTIFIED BY '${DB_PASS}';"
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'10.0.%';"
# mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'10.0.%';"
mysql -e "FLUSH PRIVILEGES;"
