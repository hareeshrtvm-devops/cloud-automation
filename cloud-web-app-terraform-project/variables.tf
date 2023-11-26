variable "AWS_REGION" {
    default = "us-east-1"
}
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "base_name" {
  description = "Enter the base name of the project. Example: assignment-dev"
}
variable "vpc_cidr" {
  description = "VPC CIDR"
  default = "10.5.0.0/23"
  type        = string
}
variable "availability_zone1" {
    description = "Avaialbility Zones"
    default = "us-east-1a"
}
variable "availability_zone2" {
    description = "Avaialbility Zones"
    default = "us-east-1b"
}
variable "availability_zone3" {
    description = "Avaialbility Zones"
    default = "us-east-1c"
}

variable "public-subnet-1-cidr" {
  description = "CIDR of public subnet-1"
  default = "10.5.0.192/26"
  type        = string
}

variable "public-subnet-2-cidr" {
  description = "CIDR of public subnet-2"
  default = "10.5.1.0/26"
  type        = string
}

variable "public-subnet-3-cidr" {
  description = "CIDR of public subnet-3"
  default = "10.5.1.64/26"
  type        = string
}

variable "private-subnet-1-cidr" {
  description = "CIDR of private subnet-1"
  default = "10.5.0.0/26"
  type        = string
}

variable "private-subnet-2-cidr" {
  description = "CIDR of private subnet-2"
  default = "10.5.0.64/26"
  type        = string
}

variable "private-subnet-3-cidr" {
  description = "CIDR of private subnet-3"
  default = "10.5.0.128/26"
  type        = string
}




