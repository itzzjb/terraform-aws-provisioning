# creating the resources here

# creating a vpc
resource "aws_vpc" "my_vpc" {
    # configuring the cidr block of the vpc
    cidr_block = "10.0.0.0/16"
    # doing some configurations
    enable_dns_hostnames = true # ensures that instances with public IP addresses get corresponding public DNS names
    enable_dns_support = true # ensures that instances can resolve domain names to IP addresses
    # adding tags to identify and filter out the vpc
    tags = {
        # by adding the Name tag, it will show the value in the UI of the aws console for the VPC
        Name = "dev"
    }
}