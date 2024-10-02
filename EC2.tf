

# # 6. Create Security Group to allow port 22,80,443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.wordpress-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_wordpress_web"
  }
}


# # 7. Create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "wordpress-able-nic" {
  subnet_id       = aws_subnet.public-subnet-1.id
  private_ips     = ["10.32.100.11"]
  security_groups = [aws_security_group.allow_web.id]

}

# # 8. Assign an elastic IP to the network interface created in step 7
resource "aws_eip" "one" {
  network_interface         = aws_network_interface.wordpress-able-nic.id
  associate_with_private_ip = "10.32.100.11"
  depends_on                = [aws_internet_gateway.wordpress-IGW]
}



# # 9. Create Linux2 server
resource "aws_instance" "wordpress-able" {
  ami               = "ami-00f07845aed8c0ee7" 
  instance_type     = "t2.micro"
  availability_zone = "eu-central-1a"
  key_name          = "naeime-macbook"
  network_interface {
    network_interface_id = aws_network_interface.wordpress-able-nic.id
    device_index = 0

  }

    user_data = <<-EOF
                  #!/bin/bash
                  yum update -y
                  yum install -y httpd php php-mysqlnd php-fpm php-json
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
                  systemctl start mariadb
                  systemctl enable mariadb
                  

                  # Set up WordPress database
                  mysql -e "CREATE DATABASE wordpress;"
                  mysql -e "CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'Salam';"
                  mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';"
                  mysql -e "FLUSH PRIVILEGES;"

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
                  sed -i 's/password_here/Salam/' /var/www/html/wp-config.php

                  systemctl restart httpd
                  EOF
  tags = {
    Name = "wordpress-instance-able"
  }
}