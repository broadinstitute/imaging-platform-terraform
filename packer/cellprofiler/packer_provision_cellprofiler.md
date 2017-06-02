# Notes on packer_template_cellprofiler_2015_09_01_ALS_Therapeutics_WoolfLab_KasperRoet_BCH.json
This document contains notes that explain this packer template, which is a JSON document. JSON doesn't allow for comments, so this supplemental markdown file serves this purpose. This packer template serves to create an instance that will then be saved as an AMI to launch future instances.

```JSON
{
  "variables": {
    "aws_access_key": "",
    "aws_secret_key": ""
  }
}
```

`aws_access_key` and `aws_secret_key` are contained within the `variables` object, because these are unique to the user and should remain secret as a measure of security. Defining these fields here allows their values to be entered from the command line when `$ packer build` is executed.

The basics of the `builders` object contain the following as outlined in the [packer docs](https://www.packer.io/intro/getting-started/build-image.html).
* access_key
* ami_name
* instance_type
* region
* secret_key
* source_ami
* ssh_username
* type

The Imaging Platform has a specific AWS configuration that the AMI must have detailed. A full list of AWS builder properties can be found in the [packer docs](https://www.packer.io/docs/builders/amazon-ebs.html). The Imaging Platform specifics are the following:
* associate_public_ip_address
* iam_instance_profile
* security_group_ids
* subnet_id
* vpc_id

```JSON
{
  "builders": [{
    "access_key": "{{user `aws_access_key`}}",
    "ami_name": "CellProfiler-Ubuntu-2015-09-01-ALS-Therapeutics-WoolfLab-KasperRoet-BCH-{{timestamp}}",
    "associate_public_ip_address" : true,
    "iam_instance_profile" : "s3-imaging-platform-role",
    "instance_type": "t2.micro",
    "region": "us-east-1",
    "secret_key": "{{user `aws_secret_key`}}",
    "security_group_ids": ["sg-c28c51bf"],
    "source_ami": "ami-40d28157",
    "ssh_username": "ubuntu",
    "subnet_id" : "subnet-d2d5c7a4",
    "type" : "amazon-ebs",
    "vpc_id" : "vpc-35149752"
}]}
```
`"{{user 'aws_access_key'}}"` is the pattern to reference input variables. The input variables can also be defined as [system variables](https://www.packer.io/docs/templates/user-variables.html). By installing [awscli](https://aws.amazon.com/cli/) and running `aws configure`, the system variables will be created automatically.

`{{timestamp}}` is a [packer configuration variable](https://www.packer.io/docs/templates/configuration-templates.html).

`"source_ami": "ami-40d28157"` is the Amazon provided version of Ubuntu 16.04 LTS with EBS General storage.

`"ssh_username": "ubuntu"` is the EC2 username by default.

`"subnet_id" : "subnet-d2d5c7a4"` is a public subnet that is part of the *cellpainting* VPC.

`"vpc_id" : "vpc-35149752"` is the *cellpainting* VPC.

```JSON
{
  "provisioners": [{
    "type": "shell",
    "script": "provision.sh"
  }]}
```

The `provisioners` json object takes the base AMI described in the `builder` and [adds custom configuration](https://www.packer.io/intro/getting-started/provision.html) that is stored in a script.
