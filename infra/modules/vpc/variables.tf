variable "project" {
  description = "The name of the project"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default = "10.0.0.0/16"
  
}

variable "availability_zones" {
  description = "List of availability zones to use for the subnets"
  type        = list(string)
  default     = ["eu-east-2a", "eu-east-2b"]
}

variable "public_subnet_cidrs" {
    type = list(string)
    default = ["10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
    type = list(string)
    default = [ "10.0.10.0/24", "10.0.11.0/24" ]
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
  
}