1. Pull the module stored on github onto the local machine.
``` bash
terraform get
```
1. Check status of the module configuration.
``` bash
terraform plan
```
1. Create the state files on the local machine.
``` bash
terraform apply
```
1. Move the state files to S3.
``` bash
terraform init
terraform apply
```
