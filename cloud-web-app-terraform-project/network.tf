resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "${var.base_name}-vpc01"
  }
}
resource "aws_subnet" "public-subnet-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = var.public-subnet-1-cidr
    map_public_ip_on_launch = "true"
    availability_zone = var.availability_zone1
    tags = {
      Name = "${var.base_name}-public-subnet-1"
    }
}
resource "aws_subnet" "public-subnet-2" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = var.public-subnet-2-cidr
    map_public_ip_on_launch = "true"
    availability_zone = var.availability_zone2
    tags = {
      Name = "${var.base_name}-public-subnet-2"
    }
}
resource "aws_subnet" "public-subnet-3" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = var.public-subnet-3-cidr
    map_public_ip_on_launch = "true"
    availability_zone = var.availability_zone3
    tags = {
      Name = "${var.base_name}-public-subnet-3"
    }
}
resource "aws_subnet" "private-subnet-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = var.private-subnet-1-cidr
    availability_zone = var.availability_zone1
    tags = {
      Name = "${var.base_name}-private-subnet-1"
    }
}
resource "aws_subnet" "private-subnet-2" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = var.private-subnet-2-cidr
    availability_zone = var.availability_zone2
    tags = {
      Name = "${var.base_name}-private-subnet-2"
    }
}
resource "aws_subnet" "private-subnet-3" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = var.private-subnet-3-cidr
    availability_zone = var.availability_zone3
    tags = {
      Name = "${var.base_name}-private-subnet-3"
    }
}
###IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    Name = "${var.base_name}-igw"
  }
}
###NAT-EIP
resource "aws_eip" "nat_eip" {
  domain = "vpc"
tags = {
  Name = "${var.base_name}-nat-eip"
  }
}
###NAT-GW
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-subnet-1.id
  tags = {
    Name = "${var.base_name}-nat-gw"
  }
}
###RT
resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags = {
    Name = "${var.base_name}-public_route"
  }
}
resource "aws_route_table" "private-route" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.natgw.id}"
  }
  tags = {
    Name = "${var.base_name}-private_route"
    
  }
}
###Pub-Subnet-association
resource "aws_route_table_association" "public-assoc-1" {
  subnet_id      = "${aws_subnet.public-subnet-1.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}
resource "aws_route_table_association" "public-assoc-2" {
  subnet_id      = "${aws_subnet.public-subnet-2.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}
resource "aws_route_table_association" "public-assoc-3" {
  subnet_id      = "${aws_subnet.public-subnet-3.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

###pvt-subnet-association
resource "aws_route_table_association" "private-assoc-1" {
  subnet_id      = "${aws_subnet.private-subnet-1.id}"
  route_table_id = "${aws_route_table.private-route.id}"
}
resource "aws_route_table_association" "private-assoc-2" {
  subnet_id      = "${aws_subnet.private-subnet-2.id}"
  route_table_id = "${aws_route_table.private-route.id}"
}
resource "aws_route_table_association" "private-assoc-3" {
  subnet_id      = "${aws_subnet.private-subnet-3.id}"
  route_table_id = "${aws_route_table.private-route.id}"
}
###ALB_SG
resource "aws_security_group" "ECS-ALB-SG" {
  name        = "${var.base_name}-ecs-alb-sg"
  description = "ingress-egress for ALB"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "${var.base_name}-ecs-alb-sg"
  }
}
###ECS SG
resource "aws_security_group" "ecs_service_sg" {
  name        = "${var.base_name}-ecs-svc-sg"
  description = "ECS SVC SG"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.ECS-ALB-SG.id]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.ECS-ALB-SG.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
###IAM role for ECS task
resource "aws_iam_role" "task_execution_role" {
  name               = "${var.base_name}-task-execution-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ecs-tasks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "task_execution_policy" {
  name               = "${var.base_name}-task-execution-policy"
  description = "IAM policy for task execution role"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowECRPull",
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowLogs",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "task_execution_attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.task_execution_policy.arn
}