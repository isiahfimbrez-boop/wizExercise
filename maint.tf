terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
provider "aws" {
  region  = "us-west-2"
  profile = "webapp"
}

#main VPC
/*
resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name = "myenv-myEKS-eks-vpc"
  }
}*/



data "aws_vpc" "eks_vpc" {
  id = "vpc-0ad9cfe190969d2b6"
}

/* import {
  to = aws_vpc.eks_vpc
  id = "vpc-0ad9cfe190969d2b6"
}
*/

# Fetch existing subnets by ID
data "aws_subnet" "private_subnet1" {
  id = "subnet-07ab3e86fa4d2732f"
}

data "aws_subnet" "private_subnet2" {
  id = "subnet-07cec67abd85e4aa7"
}


variable "vpc_id" {
  description = "VPC ID where subnets are created"
  type        = string
  default     = "vpc-0ad9cfe190969d2b6" # replace with your actual VPC ID or pass as variable
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-west-2a", "us-west-2b"]
}
/*
resource "aws_internet_gateway" "igw" {
  tags = {
    Name = "my-igw"
  }
}*/


resource "aws_subnet" "public_subnet1" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.32.0/20" # choose a CIDR block not overlapping with your private subnets
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name                                             = "public-subnet-1"
    "kubernetes.io/role/elb"                         = "1"
    "kubernetes.io/cluster/myenv-myEKS-eks-cluster2" = "owned"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.48.0/20"
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name                                             = "public-subnet-2"
    "kubernetes.io/role/elb"                         = "1"
    "kubernetes.io/cluster/myenv-myEKS-eks-cluster2" = "owned"
  }
}

/*
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet1_association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet2_association" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public.id
}
*/

/*
resource "aws_subnet" "private_subnet1" {
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.128.0/20"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "myenv-myEKS-eks-private-subnet1"
  }
}

/*
import {
  to = aws_subnet.private_subnet1
  id = "subnet-07ab3e86fa4d2732f"
} */
/*

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.16.0/20"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "myenv-myEKS-eks-private-subnet2"
  }
}
*/
/*
import {
  to = aws_subnet.private_subnet2
  id = "subnet-07cec67abd85e4aa7"
} */

/*resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "172.31.0.0/20"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "myenv-myEKS-eks-public-subnet"
  }
}

import {
  to = aws_subnet.public_subnet
  id = "subnet-0f0abc0dd79e553dc"
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "172.31.32.0/20"
  availability_zone       = "us-east-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "myenv-myEKS-eks-public-subnet2"
  }
}


import {
  to = aws_subnet.public_subnet2
  id = "subnet-032b688f449852486"
}
*/