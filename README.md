# imaging-platform-terraform
Software to use Terraform and CellProfiler together to process images on cloud-computing platforms.

# Notes about using Terraform
This repository, and related demos, has exclusively been tested in a Linux environment. Therefore users are encouraged to also use a Linux environment. For Linux users, e.g. those running Ubuntu, this is a non-issue. For Mac users, the Terminal app is recommended and, when using this software, will behave the same as a Linux terminal. For Windows users, use [*Bash on Ubuntu on Windows*](https://msdn.microsoft.com/en-us/commandline/wsl/about) on a Windows OS version 15063 or later; this corresponds to the Windows 10 Creators Update.

# An AWS example
# Configure your local system with AWS credentials
~/.aws/credentials place the aws credential files in this folder on the local machine.

# Create the remote backend bucket (do this before anything else)
1. Use the code at *github.com/broadinstitute/imaging-platform-terraform/aws_s3_bucket_remote_backend*.
1. Update *variables.tf*.
1. `terraform plan` and `terraform apply`

A bucket is created that will store state information for future infrastructure.

# aws_run_cellprofiler
Use this module to use a single EC2 instance to process a set of images.
