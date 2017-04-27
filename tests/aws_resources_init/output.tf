output "iam_role_id" {

  value = "${module.test_aws_resources_init.iam_role_id}"

}

output "sg_id" {

  value = "${module.test_aws_resources_init.sg_id}"

}

output "subnet_id" {

  value = "${module.test_aws_resources_init.subnet_id}"

}
