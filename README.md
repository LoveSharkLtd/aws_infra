This directory contains terraform script to create,plan and manage infrastructure automatically required for building Moch App.

Features

dev,staging and prod are separate environments which share nothing and they live in separate AWS accounts

0. Create aws profile name as environment variable
     Make sure profile has limited permission to build infrastructure.
     ```
     export AWS_PROFILE=circleci_sandbox
     ```
1. Initialize terraform for given provider .
     ```
     terraform init
      ```
3. Navigate to environment  e.g dev :
      ``` 
      cd dev/network
      terragrunt init 
      ```
3. Plan resources using terragrunt.
    ```
    terragrunt plan -var-file ../variables.tfvars
     ```

4. Make sure to review all resource before applying below command.
     ``` 
     terragrunt apply -var-file ../variables.tfvars
      ```


 #### Below resources are created manually

 
 1. Some of the ssm key value provided by ios team .e.g. private key of application setup manually.
    1. auth_private_key 
    2. auth_info
    3. sns_platform_app_certificate : contains certificate value from apple distribution certificate file().p12) file
    4. sns_platform_app_private_key : contain private key of dist certificate file

          