# Create a Subnet Group for RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "wordpress-rds-subnet-group"
  subnet_ids = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]

  tags = {
    Name = "wordpress-rds-subnet-group"
  }
}

# Create a Security Group for RDS
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.wordpress-vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.32.0.0/16"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress-rds-sg"
  }
}

# Create an RDS MySQL Instance (Multi-AZ)
resource "aws_db_instance" "wordpress_rds" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  identifier           = "wordpress"
  db_name              = "wordpress"
  username             = "admin"
  password             = "Salam745"  # Change this to a secure password
  parameter_group_name = "default.mysql8.0"
  multi_az             = true
  storage_type         = "gp2"
  backup_retention_period = 0
  skip_final_snapshot = true
  publicly_accessible  = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    Name = "wordpress-rds"
  }
}
