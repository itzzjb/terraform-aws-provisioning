# here are are going to use data sources of aws provider

# we can use the aws_ami data source to get an ami id according to the filters we provide
data "aws_ami" "my_ami" {
  # we need to get the most recent ami id
  most_recent = true
  # we need to provide the owner id of the ami (can get using the AWS console)
  # we need to use brackets because it is a list
  owners = ["099720109477"]
  # we need to provide the filter
  filter {
    # we are using the filter type called name
    name = "name"
    # we are only getting the latest version of ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*
    # we used * because when versions changes only the date at that part changes
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}
# we can use the ami id that is outputted by this data source when creating instances