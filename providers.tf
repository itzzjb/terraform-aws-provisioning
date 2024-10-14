terraform {
  # here we specify the data required by terraform to install the plugins for the providers
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Configure the AWS provider
# we have already logged into the aws using the aws cli (aws configure command)
# the data about the user will be stored in the creadential file, and the user name will be "default" by default when we use this command
# you can add more users that have different names by editing the credentials file
provider "aws" {
  # adding the name of the user that we setup in the credentials file
  profile = "default"
  # region is mandatory
  region =  "us-east-1"
}
