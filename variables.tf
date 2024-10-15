# all the variables should be defined here
# but for now, we will only define the variables of the vpc here
variable "vpc_cidr_block" {
  type = string
  description = "The CIDR block for the VPC"
  default = "10.0.0.0/16"
}
variable "enable_dns_support" {
  type = bool
  description = "A boolean flag to enable/disable DNS support in the VPC"
  default = true
}
variable "enable_dns_hostnames" {
  type = bool
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  default = true
}

