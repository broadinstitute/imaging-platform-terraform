output "iam_role_id" {

  value = "${module.test_aws_resources_init.aws_iam_role.imaging-platform-terraform.id}"

}

output "sg_id" {

  value = "${module.test_aws_resources_init.aws_security_group.imaging-platform-terraform-cellprofiler.id}"

}

output "subnet_id" {

  value = "${module.test_aws_resources_init.aws_subnet.imaging-platform-terraform-cellprofiler.id}"

}
