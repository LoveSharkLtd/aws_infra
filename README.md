This directory contains mochi entire infrasrture

Features
prod and dev are separate environments which share nothing and they live in separate AWS accounts

1. terraform init 
2. navigate to environment :
 e.g. cd dev/network
 terraform init
 terraform plan -var-file ../variables.tfvars

 terraform apply -var-file ../variables.tfvars