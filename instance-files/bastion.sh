#!/bin/bash
yum update -y
yum install -y telnet net-tools

touch /etc/yum.repos.d/MariaDB.repo
echo "[mariadb]" >> /etc/yum.repos.d/MariaDB.repo
echo "name=MariaDB" >>  /etc/yum.repos.d/MariaDB.repo
echo "baseurl=https://mirror.mariadb.org/yum/11.6/rhel/9Server/x86_64/" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgkey=https://rpm.mariadb.org/RPM-GPG-KEY-MariaDB" >>  /etc/yum.repos.d/MariaDB.repo
echo "gpgcheck=1" >>  /etc/yum.repos.d/MariaDB.repo
yum install -y mariadb-server 
chmod 600 /home/ec2-user/.ssh/key.pem
sudo chown ec2-user:ec2-user /home/ec2-user/.ssh/key.pem