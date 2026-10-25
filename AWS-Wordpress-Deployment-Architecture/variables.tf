variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "project" {
  description = "The project name"
  type        = string
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
}

variable "public_subnet_cidr_1" {
  description = "The CIDR block for the public subnet"
  type        = string
}

variable "public_subnet_cidr_2" {
  description = "The CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = string
}

variable "ami" {
  description = "The AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for the EC2 instances"
  type        = string
}

