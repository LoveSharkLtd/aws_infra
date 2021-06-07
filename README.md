This directory contains terraform script to create,plan infrastructure automatically required for building Moch App.

Features

dev,stagin,dev are separate environments which share nothing and they live in separate AWS accounts

1. terraform init 
2. navigate to environment :
 e.g. cd dev/network
 terraform init
3. terraform plan -var-file ../variables.tfvars

4. Make sure to review before applying below command.
   terraform apply -var-file ../variables.tfvars 


 #### Below resources are created manually

 1. Cloudfront for mochi appi to read posts and games from s3 bucket
 2. SNS configured for each ios build manually . It needs to upload ios distribution certificate while creating platform application .
 3. Some of the ssm key value provided by ios team .e.g. private key of application setup manually.
    1. build/pri_key