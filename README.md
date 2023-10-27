# AWS Terraform Project
## Requirements
### AWS/Terraform
- Create a network with public and private subnets
- Provision an ECS cluster and load balancer
- Add an ECS service that serves the base nginx image
- Set the default route for the ALB that serves the default route of the nginx image
- Create an S3 bucket and configure the Terraform to allow the nginx task to write to the S3 bucket
### Python
- Write a CLI that exposes two commands (these are listed in commands.txt)
  - One command to list the files in the S3 bucket created in the first step
  - One command lists the versions of the ECS task definition for the service created in step 1
