1. Pull the module stored on github onto the local machine.
``` bash
terraform get
```
1. Check status of the module configuration.
``` bash
terraform plan
```
1. Set the state files location to S3.
``` bash
terraform init
```
1. Create the resources
``` bash
terraform apply
```
# Troubleshooting
## Recreating a resource
1. Use `terraform taint`. For example:
```bash
terraform taint -module=test_aws_resources_init aws_subnet.imaging-platform-terraform
```
## Remote backend
The S3 bucket that will store terraform state information must be created ahead of time.

`terraform refresh` will update any output variables if there have been changes to the infrastructure.
