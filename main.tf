terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}
######################
#vpc A
#############################
resource "aws_vpc" "vpc-test" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc-test"
  }
}
#subnet
resource "aws_subnet" "sub-private-test" {
  vpc_id     = aws_vpc.vpc-test.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "sub-private-test"
  }
}

resource "aws_subnet" "sub-public-test" {
  vpc_id     = aws_vpc.vpc-test.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "sub-public-test"
  }
}

#internet gateway
resource "aws_internet_gateway" "ig-test" {
  vpc_id = aws_vpc.vpc-test.id
  tags = {
    Name = "ig-test"
  }
}
#route table
resource "aws_route_table" "rt-test" {
  vpc_id = aws_vpc.vpc-test.id
  tags = {
    Name = "rt-test"
  }
}

#route
resource "aws_route" "route_test" {
  route_table_id = aws_route_table.rt-test.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig-test.id
}
#route table association
resource "aws_route_table_association" "rt-ass-test" {
  subnet_id      = aws_subnet.sub-public-test.id
  route_table_id = aws_route_table.rt-test.id
}

###########################33
#VPC B
###########3    

resource "aws_vpc" "vpc-prod" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "vpc-prod"
  }
}

resource "aws_subnet" "sub-public-prod" {
  vpc_id     = aws_vpc.vpc-prod.id
  cidr_block = "10.1.2.0/24"
  tags = {
    Name = "sub-public-prod"
  }
}

resource "aws_subnet" "sub-private-prod" {
  vpc_id     = aws_vpc.vpc-prod.id
  cidr_block = "10.1.1.0/24"
  tags = {
    Name = "sub-private-prod"
  }
}

resource "aws_internet_gateway" "ig-prod" {
  vpc_id = aws_vpc.vpc-prod.id
  tags = {
    Name = "ig-prod"
  }
}

resource "aws_route_table" "rt-prod" {
  vpc_id = aws_vpc.vpc-prod.id
  tags = {
    Name = "rt-prod"
  }
}

resource "aws_route" "route_prod" {
  route_table_id = aws_route_table.rt-prod.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig-prod.id
}

resource "aws_route_table_association" "rt-ass-prod" {
  subnet_id      = aws_subnet.sub-public-prod.id
  route_table_id = aws_route_table.rt-prod.id
}

######################
#security group
###########3########

resource "aws_security_group" "allow_ssh-a" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc-test.id

  ingress {
    description = "SSH from VPC"
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
}

resource "aws_security_group" "allow_ssh-b" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc-prod.id

  ingress {
    description = "SSH from VPC"
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
}

resource "aws_instance" "ec2_a" {
  ami           = "ami-03446a3af42c5e74e" # change based on region
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.sub-public-test.id
  vpc_security_group_ids = [aws_security_group.allow_ssh-a.id]
  key_name      = "terra-key"
  tags = { Name = "ec2_a" }
}

resource "aws_instance" "ec2_b" {
  ami           = "ami-03446a3af42c5e74e" # change based on region
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.sub-public-prod.id
  vpc_security_group_ids = [aws_security_group.allow_ssh-b.id]
  key_name      = "terra-key"
  tags = { Name = "ec2_b" }
}
