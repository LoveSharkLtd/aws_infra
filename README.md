
Mochi Infrastructure (IaC)
=========================

This directory contains terraform scripts to create, plan and manage 
infrastructure required by the Mochi app.

If you are interested in learning more about terraform, please check out the 
[Getting Started guides](https://learn.hashicorp.com/terraform#getting-started).

Prerequisites
-------------
- Terraform
- Terragrunt

Remote state resource creation
------------------------------
This step only needs to be done once for each environment.
   
- If you're deploying to a new environment, create a new folder for it
- Navigate to environment folder and initialize terraform. 
    - Export AWS_ACCESS_KEY and AWS_SECRET_KEY environment variables, or just
      export an AWS_PROFILE environment variable, e.g.
      ```
    	export AWS_PROFILE=circleci_sandbox
      ```
    
    - The **main.tf** file in each environment('dev/main.tf') only defines an S3
	  bucket and a DynamoDB table for storing state. Initialize terraform with
      ```
		terraform init
      ```
    - Review the resources that will be created with
      ```
        terraform plan
      ```
    - Create resources by executing the command below. This should only create 2
	  resources, the S3 bucket and a DynamoDB instance.
      ``` 
        terraform apply
      ```
     

Provisioning the rest of the resources
-------------------------------
The dev, staging, and production environments all live in separate AWS accounts.
Make sure to export the correct AWS credentials for the account in which resources
will be provisioned.

Each application also has its own module - we have separate nested modules under
`modules/mochi` and `modules/cms`.

### Before provisioning
Some resources require us to manually create some parameters in the SSM parameter
store with specific names before they are provisioned and deployed. Currently, these are:

1. auth_private_key 
2. auth_info
3. sns_platform_app_certificate : contains certificate value from apple distribution certificate file().p12) file
4. sns_platform_app_private_key : contain private key of dist certificate file
5. redshift_master_username
6. redshift_master_password


### Planning & provisioning

0.  Make sure you are using the correct AWS credentials, and that the user has
    the correct set of permissions
    ```
    export AWS_PROFILE=circleci_sandbox
    ```
1. Initialize `terragrunt` in the directory of the resource you want to provision,
   e.g. 'dev/mochi/network'
    ```
    cd dev/mochi/network
    terragrunt init
    ```
     
2. Plan the resources to be provisioned using `terragrunt`
    ```
    terragrunt plan -var-file ../variables.tfvars
    ```

4. Review all resources to ensure they are correct before actually provisioning
    ``` 
    terragrunt apply -var-file ../variables.tfvars
    ```

### Encryption of database credentials

Confidential data can be encrypted using AWS KMS. 
Only users with administrator access can encrypt files using AWS KMS.
    
``` 
aws kms encrypt --key-id <key_id> \
                --region <region> \
				--plaintext fileb://<file.yml> \
				--output text \
				--query CiphertextBlob > <file.yml.encrypted> 
``` 

The encrypted output file of the command above should be checked into the corresponding 
environment database resource directory e.g. dev/mochi/database/db.yml.encrypted

Decrypt files with the command below, replacing <encrypted_text> with the text
of the encrypted file.

``` 
aws kms decrypt --ciphertext-blob fileb://<(echo "<encrypted_text>" | base64 -D) \
 				--output text \
				--query Plaintext \
				--region <<region> | base64 -D > <decrypted_file.yml>
```
