
Mochi Infrastructure (IaC)
=========

This directory contains terraform scripts to create, plan and manage infrastructure required by the Mochi app.

If you are interested in learning more about terraform, please check out the [Getting Started guides](https://learn.hashicorp.com/terraform#getting-started) on HashiCorp's learning platform.


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
 We've created module for each application .e.g we have mochi and cms as module in current infrastucture

0.  **Make sure profile has limited permission to build infrastructure.**
     ```
     export AWS_PROFILE=circleci_sandbox
     ```
1. Initialize terrgrunt in each resource of respective application e.g. 'dev/mochi/network .
     ```
     cd dev/mochi/network
     terragrunt init
      ```
     
2. Plan resources using terragrunt within resources folder of respective application  e.g. 'dev/mochi/network .
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
 2. Confidential data encrypted using aws KMS key and only administrator can encrypt the file using aws kms and key-id of alias "mochi_secrets" command below.
    
    ``` 
    aws kms encrypt --key-id <<key_id>> --region eu-west-1 --plaintext fileb://<<file.yml>  —output text --query CiphertextBlob ><<file.yml>.encrypted 
    ``` 
   Output file of above command <file.yml>.encrypted checked into each environments repository . e.g. dev/db.yml.encrypted

   You can use below command to decrypt it.Copy the content of .encryped filed and put at <<encrypted_text>>

   ``` 
    aws kms decrypt --ciphertext-blob fileb://<(echo "<<encrypted_text>>" | base64 -D) --output text --query Plaintext --region <<region> | base64 -D > <<file_descrypted.yml>>
   ```
