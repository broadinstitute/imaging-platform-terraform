output "iam_role_id" {

  value = "${aws_iam_role.imaging-platform-terraform.name}"

}

output "sg_id" {

  value = "${aws_security_group.imaging-platform-terraform-cellprofiler.id}"

}

output "subnet_id" {

  value = "${aws_subnet.imaging-platform-terraform-cellprofiler.id}"

}
