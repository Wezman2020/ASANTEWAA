#VPC
resource "aws_vpc" "bobo-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "bobo-vpc"
  }
}

#PUBLIC SUBNETS
resource "aws_subnet" "public-sub-1" {
  vpc_id     = aws_vpc.bobo-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-sub-1"
  }
}

resource "aws_subnet" "public-sub-2" {
  vpc_id     = aws_vpc.bobo-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "public-sub-2"
  }
}

#PRIVATE SUBNETS
resource "aws_subnet" "private-sub-1" {
  vpc_id     = aws_vpc.bobo-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "private-sub-1"
  }
}

resource "aws_subnet" "private-sub-2" {
  vpc_id     = aws_vpc.bobo-vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "private-sub-2"
  }
}

#CREATE ROUTE TABLES

#PUBLIC ROUTE TABLE
resource "aws_route_table" "public-route-BOOB" {
  vpc_id = aws_vpc.bobo-vpc.id

  tags = {
    Name = "public-route-BOOB"
  }
}

#PRIVATE ROUTE TABLE
resource "aws_route_table" "private-route-BOOB" {
  vpc_id = aws_vpc.bobo-vpc.id

  tags = {
    Name = "private-route-BOOB"
  }
}


#ROUTE TABLE ASSOCIATIONS
resource "aws_route_table_association" "public-route-1-association" {
  subnet_id      = aws_subnet.public-sub-1.id
  route_table_id = aws_route_table.public-route-BOOB.id
}

resource "aws_route_table_association" "public-route-2-association" {
  subnet_id      = aws_subnet.public-sub-2.id
  route_table_id = aws_route_table.public-route-BOOB.id
}

resource "aws_route_table_association" "private-route-1-association" {
  subnet_id      = aws_subnet.private-sub-1.id
  route_table_id = aws_route_table.private-route-BOOB.id
}

resource "aws_route_table_association" "private-route-2-association" {
  subnet_id      = aws_subnet.private-sub-2.id
  route_table_id = aws_route_table.private-route-BOOB.id
}

#INTERNET GATEWAY
resource "aws_internet_gateway" "yaa-igw" {
  vpc_id = aws_vpc.bobo-vpc.id

  tags = {
    Name = "yaa-igw"
  }
}

#IGW ROUTE
resource "aws_route" "yaa-igw-association" {
  route_table_id            = aws_route_table.public-route-BOOB.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.yaa-igw.id
} 
#CREATE ELASTIC IP
resource "aws_eip" "JOE-EIP" {
}

#CREATE NAT GATEWAY
resource "aws_nat_gateway" "yaa-Nat-gateway" {
  allocation_id = aws_eip.JOE-EIP.id
  subnet_id     = aws_subnet.public-sub-1.id
  }

  #CREATE NGW ROUTE
  resource "aws_route" "yaa-Nat-association" {
    route_table_id            = aws_route_table.private-route-BOOB.id
    destination_cidr_block    = "0.0.0.0/0"
    gateway_id                = aws_nat_gateway.yaa-Nat-gateway.id
  }