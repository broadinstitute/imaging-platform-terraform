# imaging-platform-terraform
# aws_resources_init
Terraform configuration files to create the infrastructure common to the image processing infrastructure. This includes a bucket to capture terraform state, security groups, and iam roles.

## vpc_id

AWS caps the number of VPCs available to an account. Currently, and this is a "bug" the vpc_id must be hard coded, because we do not have the capacity to create a new VPC with Terraform due to this cap. Until this is resolved, the vpc_id to use is *vpc-35149752*.

## region

*us-east-1* is currently the exclusive region we have AWS resources, so this is hard-coded in *provider_aws.tf*.
