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

# we need to create a security group that we will use for the ec2
resource "aws_security_group" "my_security_group" {
  # security group has a name attribute. So, we do not need to tag it. 
  name = "dev-security-group"
  # then we can provide a description
  description = "dev security group"
  # then we need to provide the vpc id
  vpc_id = aws_vpc.my_vpc.id
  # next we need to provide ingress and egress
  # they are defined in seperate blocks inside this resource block
  # or we can use seperate resource blocks to do so

  # ingress block
  # manages inbound rules for the security group
  ingress {
    # we need to specify the port range
    from_port = 0
    to_port   = 0
    # then we need to specify the protocol
    protocol    = "-1"                   # here we use -1 to specify all protocols
    cidr_blocks = ["112.134.129.252/32"] # we only need to list ip addresses that we are going to access through here (like personal ip address)
    # we need to add /32 as the subnet must which will specify a single ip
    # here we have allowed our ipaddress to use any port and protocol to access throught the security group
  }

  # egress block
  # manages outbound rules for the security group
  egress {
    # we need to specify the port range
    from_port = 0
    to_port   = 0
    # then we need to specify the protocol
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # here we are going to allow all the ipaddresses 
  }

}

# now we are going to create the key-value pair that we are going to use in the instance
resource "aws_key_pair" "my_key_pair" {
  # we can pass the name here. no need of tags
  key_name = "terraformkey"
  # we have used ssh-key gen command and created a public key and a private key in the ~/.ssh directory
  # instead of hardcoding the public key we can use the file method to use the .pub file from the local system that contains the public key
  public_key = file("~/.ssh/terraformkey.pub")
}