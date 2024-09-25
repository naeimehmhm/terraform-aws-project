
# # 1. Create vpc
resource "aws_vpc" "vpc-dev" {
  cidr_block = "10.32.0.0/16"

  tags = {
    Name = "vpc-dev"
  }
}

# # 2. Create Internet Gateway

resource "aws_internet_gateway" "igw-dev" {
  vpc_id = aws_vpc.vpc-dev.id
  tags = {
    Name = "IGW-Dev"
  }
}



# # 4. Create a Subnet 
resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.vpc-dev.id
  cidr_block        = "10.32.100.0/24"
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch= "true"
  tags = {
    Name = "public-subnet-1"
  }
}
# # 3. Create Custom Route Table
resource "aws_route_table" "dev-route-table" {
  vpc_id = aws_vpc.vpc-dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-dev.id
  }

  tags = {
    Name = "Dev"
  }
}

# # 5. Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.dev-route-table.id
}

# # 6. Create Security Group to allow port 22,80,443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.vpc-dev.id

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
    Name = "allow_web"
  }
}

# # 7. Create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "wordpress-able-nic" {
  subnet_id       = aws_subnet.public-subnet-1.id
  private_ips     = ["10.32.100.11"]
  security_groups = [aws_security_group.allow_web.id]

}

# # # 8. Assign an elastic IP to the network interface created in step 7
# resource "aws_eip" "one" {
#   network_interface         = aws_network_interface.wordpress-able-nic.id
#   associate_with_private_ip = "10.32.100.11"
#   depends_on                = [aws_internet_gateway.igw-dev]
# }

# # 9. Create Linux2 server
resource "aws_instance" "wordpress-able" {
  ami               = "ami-00f07845aed8c0ee7" 
  instance_type     = "t2.micro"
  availability_zone = "eu-central-1b"
  key_name          = "naeime-macbook"
  network_interface {
    network_interface_id = aws_network_interface.wordpress-able-nic.id
    device_index = 0

  }

    user_data = <<-EOF
                  #!/bin/bash
                  sudo apt update -y
                  sudo apt install mysql nginx php php-mysql -y
                  sudo systemctl start mysql
                  sudo systemctl start nginx
                  cd /tmp && wget https://wordpress.org/latest.tar.gz
                  sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                  EOF
  tags = {
    Name = "wordpress-able"
  }
}