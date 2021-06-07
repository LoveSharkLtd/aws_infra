This directory contains terraform script to create,plan and manage infrastructure automatically required for building Moch App.

Features

dev,staging and prod are separate environments which share nothing and they live in separate AWS accounts

1. Initialize terraform for given provider
     ```
     terraform init
      ```
3. Navigate to environment  e.g dev :
      ``` 
      cd dev/network
      terraform init 
      ```
3. Plan resources.
    ```
    terraform plan -var-file ../variables.tfvars
     ```

4. Make sure to review all resource before applying below command.
     ``` 
     terraform apply -var-file ../variables.tfvars
      ```


 #### Below resources are created manually

 1. Cloudfront for mochi appi to read posts and games from s3 bucket
 2. SNS configured for each ios build manually . It needs to upload ios distribution certificate while creating platform application .
 3. Some of the ssm key value provided by ios team .e.g. private key of application setup manually.
    1. auth_private_key 
    2. auth_info
