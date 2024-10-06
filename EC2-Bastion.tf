

# # 6. Create Security Group to allow port 22
resource "aws_security_group" "allow_bastion" {
  name        = "allow_bastion_traffic"
  description = "Allow bastion inbound traffic"
  vpc_id      = aws_vpc.wordpress-vpc.id

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
    Name = "allow_bastion_ssh"
  }
}


# # 7. Create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "bastion-able-nic" {
  subnet_id       = aws_subnet.public-subnet-1.id
  private_ips     = ["10.32.100.12"]
  security_groups = [aws_security_group.allow_bastion.id]

}

# # 8. Assign an elastic IP to the network interface created in step 7
resource "aws_eip" "one" {
  network_interface         = aws_network_interface.bastion-able-nic.id
  associate_with_private_ip = "10.32.100.12"
  depends_on                = [aws_internet_gateway.wordpress-IGW]
}



# # 9. Create Linux2 server
resource "aws_instance" "bastion-able" {
  ami               = "ami-00f07845aed8c0ee7" 
  instance_type     = "t2.micro"
  availability_zone = "eu-central-1a"
  key_name          = "naeime-macbook"
  network_interface {
    network_interface_id = aws_network_interface.bastion-able-nic.id
    device_index = 0

  }

  tags = {
    Name = "bastion-instance-able"
  }
}