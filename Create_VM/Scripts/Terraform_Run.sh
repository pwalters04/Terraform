# Usage: Create VM in Azure via Terraform
# Notes: Uses Default Sub

#!/bin/bash

echo "------ Init Teraform ------"
terraform init

echo " "
echo "------ Format Terraform -------"
terraform fmt

echo " "
echo "------ Plan Terraform -------"
terraform plan

echo " "
echo "------ Apply Terraform -------"
terraform apply

echo " "
echo "------ Show VM  IN Azure -------"

#az login

#az vm show --resource-group Sandbox --name SandboxVM -d query [publicIps] --o tsv 

echo " "
echo "------ Login into  VM  -------"

#ssh sandboxadmin@<publicIps>


