variable "aws_region" {
  default = "us-east-1"
}

variable "ec2_ami" {
  default = "ami-06878d265978313ca"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ec2_keypair" {
  default = "ass-key"
}

variable "environment" {
  default = "dev"
}

variable "provision_instance" {
  type        = bool
  default     = true
  description = "Flag to control whether to run the Ansible playbook on the instance"
}

variable "private_key_path" {
  default = "~/terraform-assignment/ass-key.cer"
}

# VPC Requirement

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# Route53
variable "domain_name" {
  default = "anjorin.me"
}

variable "record_name" {
  default = "www"
}
