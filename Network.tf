
# # 1. Create vpc
resource "aws_vpc" "wordpress-vpc" {
  cidr_block = "10.32.0.0/16"

  tags = {
    Name = "wordpress-vpc"
  }
}

# # 2. Create Internet Gateway

resource "aws_internet_gateway" "wordpress-IGW" {
  vpc_id = aws_vpc.wordpress-vpc.id
  tags = {
    Name = "wordpress-IGW"
  }
}

# # 3. Create a Subnet 
resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.wordpress-vpc.id
  cidr_block        = "10.32.100.0/24"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch= "true"
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id            = aws_vpc.wordpress-vpc.id
  cidr_block        = "10.32.101.0/24"
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch= "true"
  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.wordpress-vpc.id
  cidr_block        = "10.32.10.0/24"
  availability_zone = "eu-central-1a"
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.wordpress-vpc.id
  cidr_block        = "10.32.11.0/24"
  availability_zone = "eu-central-1b"
  tags = {
    Name = "private-subnet-2"
  }
}

# # 4. Create Custom Route Table

resource "aws_route_table" "wordpress-rtb-public" {
  vpc_id = aws_vpc.wordpress-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wordpress-IGW.id
  }

  tags = {
    Name = "wordpress-rtb-public"
  }
}
# Associate the public route table with public subnets in both AZs
resource "aws_route_table_association" "public_assoc_az1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.wordpress-rtb-public.id
}

resource "aws_route_table_association" "public_assoc_az2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.wordpress-rtb-public.id
}




# # # # 5 Create NAT gateway
# resource "aws_eip" "nat" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public-subnet-1.id
#   tags = {
#     Name = "nat-gateway"
#   }
# }

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.wordpress-vpc.id
  tags = {
    Name = "private-route-table"
  }
}

# # Create a route for private subnets to the NAT Gateway for outbound internet access
# resource "aws_route" "private_route" {
#   route_table_id         = aws_route_table.private_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat.id
# }

# Associate the private route table with private subnets in both AZs
resource "aws_route_table_association" "private_assoc_az1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_az2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private_rt.id
}
