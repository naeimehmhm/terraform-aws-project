#!/bin/bash
yum update -y
yum install -y httpd php php-mysqlnd php-fpm php-json telnet net-tools
systemctl start httpd
systemctl enable httpd
# Install MySQL and set up database
touch /etc/yum.repos.d/MariaDB.repo
echo "[mariadb]" >> /etc/yum.repos.d/MariaDB.repo
echo "name=MariaDB" >>  /etc/yum.repos.d/MariaDB.repo
echo "baseurl=https://mirror.mariadb.org/yum/11.6/rhel/9Server/x86_64/" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgkey=https://rpm.mariadb.org/RPM-GPG-KEY-MariaDB" >>  /etc/yum.repos.d/MariaDB.repo
echo "gpgcheck=1" >>  /etc/yum.repos.d/MariaDB.repo
yum install -y mariadb-server 
#   systemctl start mariadb
#   systemctl enable mariadb
#  # Set up WordPress database
#  mysql -e "CREATE DATABASE wordpress;"
#  mysql -e "CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'Salam';"
#  mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';"
#  mysql -e "FLUSH PRIVILEGES;"
# Download and install WordPress
wget http://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/
# Set permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html
# Create wp-config.php
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i 's/database_name_here/wordpress/' /var/www/html/wp-config.php
sed -i 's/username_here/wp_user/' /var/www/html/wp-config.php
sed -i 's/password_here/Salam745/' /var/www/html/wp-config.php
sed -i "s/localhost/${aws_db_instance.wordpress_rds.address}/" /var/www/html/wp-config.php
systemctl restart httpd