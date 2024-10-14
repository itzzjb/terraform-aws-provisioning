# creating all the resources here

# creating a vpc
resource "aws_vpc" "my_vpc" {
  # configuring the cidr block of the vpc
  cidr_block = "10.0.0.0/16"
  # doing some configurations
  enable_dns_hostnames = true # ensures that instances with public IP addresses get corresponding public DNS names
  enable_dns_support   = true # ensures that instances can resolve domain names to IP addresses
  # adding tags to identify and filter out the vpc
  tags = {
    # by adding the Name tag, it will show the value in the UI of the aws console for the VPC
    Name = "dev"
  }
}

# creating a subnet (public)
resource "aws_subnet" "my_public_subnet" {
  # need to specify the vpc that we are going to use for the public subnet (aws_vpc.my_vpc)
  # getting the the id using the output reference variable
  vpc_id = aws_vpc.my_vpc.id
  # configure the cidr_block of the subnet inside the cidr_block of the vpc
  cidr_block = "10.0.1.0/24"
  # this will make this subnet a public subnet
  map_public_ip_on_launch = true
  # we need to specify an availability zone for a subnet
  availability_zone = "us-east-1a"
  # adding a tag
  tags = {
    Name = "dev-public"
  }
}

# internet gateway is added to a specific vpc
resource "aws_internet_gateway" "my_internet_gateway" {
  # we need to add the vpc id
  vpc_id = aws_vpc.my_vpc.id
  # adding some tags
  tags = {
    Name = "dev-igw"
  }
}

# now we need to create a route table to route traffic from subnet to internet gateway
# we can define the routes inline or we can use a seperate route resource
resource "aws_route_table" "my_route_table" {
  # adding the vpc id
  vpc_id = aws_vpc.my_vpc.id
  # adding some tags
  tags = {
    Name = "dev-route-table"
  }
}

# let's create the route resource
# this is an entry on the route table
resource "aws_route" "my_route" {
  # we need to give the route table id
  route_table_id = aws_route_table.my_route_table.id
  # all ip addresses should head for this gateway
  destination_cidr_block = "0.0.0.0/0"
  # need to pass in the internet gateway id
  gateway_id = aws_internet_gateway.my_internet_gateway.id
}

# we need to bridge the gap between the subnet and the route table
# route_table_association create an association between a route table and a subnet, internet gateway, or a virtual private gateway.
resource "aws_route_table_association" "my_route_table_association" {
  # we need to give the subnet id
  subnet_id = aws_subnet.my_public_subnet.id
  # we need to give the route table id
  route_table_id = aws_route_table.my_route_table.id
}