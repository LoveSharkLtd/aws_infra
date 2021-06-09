
Mochi Infrastructure (IaC)
=========

This directory contains terraform script to create,plan and manage infrastructure automatically required for building Moch App.

If you are interested to learn terraform,please check out our [Getting Started guides](https://learn.hashicorp.com/terraform#getting-started) on HashiCorp's learning platform. There are also [additional guides](https://learn.hashicorp.com/terraform#operations-and-development) to continue your learning.


Remote state resource creation
-------------------------------
This step is one-time setup for each environment

- Create new folder for each environment e.g. dev
- Navigate to environment folder and initialize terraform. 
     - Export AWS_ACCESS_KEY, AWS_SECRETE_KEY or AWS_PROFILE.

       ```
         export AWS_PROFILE=circleci_sandbox
       ```
     
    - **main.tf** of each environment('dev/main.tf') contains only remotes resources s3 bucket and dynamo db for storing state.Initialize terraform
      ```
         terraform init
       ```
    - Review resources by executing below command
      ```
         terraform plan
      ```
    - Create resources by executing below command.Make sure to reveiw resources to be added/changed/destroyed before typing yes.This will create only 2 resources 1. s3 bucket for storing terraform state and dynamodb.
      ``` 
         terraform apply
      ```
     

Provisioning Resources once remote state for environment ready.
-------------------------------
Each environment lives in seperate aws account.Make sure to export AWS_ACCESS_KEY ,AWS_SECRETE_KEY or AWS_PROFILE for aws account on which you are going to provision resources.

0.  **Make sure profile has limited permission to build infrastructure.**
     ```
     export AWS_PROFILE=circleci_sandbox
     ```
1. Initialize terrgrunt in each resource e.g. 'dev/network .
     ```
     cd dev/network
     terragrunt init
      ```
     
2. Plan resources using terragrunt within resources folder e.g. 'dev/network .
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

          
