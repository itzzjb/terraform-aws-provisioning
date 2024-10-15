We are going to provision this infrastructure using Terraform

![Screenshot 2024-10-14 103847](https://github.com/user-attachments/assets/1d98c593-3bef-4330-9afc-d570d188b28b)

### Some Commands
```sh
# shows the state of all resources
terraform show
```
```sh
# shows the state of a specific resource
terraform state show my_resource
```
```sh
# shows a list of resources
terraform state list
```
```sh
# getting rid of the confirmation dialog
# very useful in automation
terraform apply -auto-approve
terraform destroy -auto-approve
```
```sh
# to replace a resource that is already applied 
# situations where only using terraform apply command won't show change (like when we add provisioners)
terraform apply -replace aws_instance.my_instance
```
```sh
