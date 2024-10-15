# all the variables should be defined here
# default value will be provided in terraform.tfvars file

# vpc
variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}
variable "enable_dns_support" {
  type        = bool
  description = "A boolean flag to enable/disable DNS support in the VPC"
}
variable "enable_dns_hostnames" {
  type        = bool
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
}

# to be continued ...