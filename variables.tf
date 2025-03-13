variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "dmz_subnet_cidr" {
  description = "CIDR block for the DMZ subnet (public)"
  default     = "10.0.1.0/24"
}

variable "web_subnet_cidr" {
  description = "CIDR block for the Web subnet (private)"
  default     = "10.0.2.0/24"
}

variable "app_subnet_cidr" {
  description = "CIDR block for the App subnet (private)"
  default     = "10.0.3.0/24"
}

variable "db_subnet_cidr" {
  description = "CIDR block for the DB subnet (private)"
  default     = "10.0.4.0/24"
}

variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI ID"
  default     = "ami-0d0f28110d16ee7d6"  
}
