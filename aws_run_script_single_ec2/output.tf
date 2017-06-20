output "id" {

  value = "${module.imaging-platform-terraform-run-script-single-ec2.id}"

}

output "public_ip" {

  value = "${aws_instance.imaging-platform-terraform-run-script-single-ec2.public_ip}"

}
