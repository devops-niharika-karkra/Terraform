#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt update -y && apt install -y apache2 php php-mysql mysql-client \
 libapache2-mod-php php-zip php-curl php-gd php-mbstring php-xml php-xmlrpc curl

systemctl enable apache2
systemctl start apache2

cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
cp -a /tmp/wordpress/* /var/www/html/
mv /var/www/html/index.html /var/www/html/apache.htmlb

cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

DB_NAME="wordpress"
DB_USER="wp_user"
DB_PASS="Password@123"
DB_HOST="__DB_HOST__"

sed -i "s/database_name_here/${DB_NAME}/" /var/www/html/wp-config.php 
sed -i "s/username_here/${DB_USER}/" /var/www/html/wp-config.php 
sed -i "s/password_here/${DB_PASS}/" /var/www/html/wp-config.php 
sed -i "s/localhost/${DB_HOST}/" /var/www/html/wp-config.php 

cat > /tmp/wp-extra.php <<'EOF'
if (isset($_SERVER['HTTP_HOST'])) {
    define('WP_HOME', 'http://' . $_SERVER['HTTP_HOST']);
    define('WP_SITEURL', 'http://' . $_SERVER['HTTP_HOST']);
}
EOF
sed -i "/stop editing/r /tmp/wp-extra.php" /var/www/html/wp-config.php

chown -R www-data:www-data /var/www/html/
find /var/www/html/ -type d -exec chmod 755 {} \;
find /var/www/html/ -type f -exec chmod 644 {} \;

systemctl restart apache2

for i in $(seq 1 30); do
  if mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "SELECT 1;" >/dev/null 2>&1; then
    echo "Database reachable"
    break
  fi
  echo "Waiting for database ($i/30)..."
  sleep 10
done

