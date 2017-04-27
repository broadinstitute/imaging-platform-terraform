1. Pull the module stored on github onto the local machine.
``` bash
terraform get
```
If it is necessary to collect changes, then use `terraform get -update`.
1. Check status of the module configuration.
``` bash
terraform plan
```
1. Create the state files on the local machine.
``` bash
terraform apply
```

# Troubleshooting
## Recreating a resource
1. Use `terraform taint`. For example:
```bash
terraform taint -module=test_aws_resources_init aws_subnet.imaging-platform-terraform
```
## A note about the remote backend
This resource is unique in that it needs to be available at the earliest moment of terraform activity. Therefore, it is configured first and separately from other resources.
