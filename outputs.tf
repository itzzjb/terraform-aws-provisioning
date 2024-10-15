# we can use this to output varibles that are outuputted by the resources created using terraform
output "instance_public_ip" {
  # we can get the public ip value that is outputted by aws_instance resource when created
  value = aws_instance.my_instance.public_ip
}