# imaging-platform-terraform
Software to use Terraform and CellProfiler together to process images on cloud-computing platforms.

# An AWS example
# Configure your local system with AWS credentials
~/.aws/credentials place the aws credential files in this folder on the local machine.

# Create the remote backend bucket (do this before anything else)
1. Use the code at *github.com/broadinstitute/imaging-platform-terraform/aws_s3_bucket_remote_backend*.
1. Update *variables.tf*.
1. `terraform plan` and `terraform apply`

A bucket is created that will store state information for future infrastructure.
