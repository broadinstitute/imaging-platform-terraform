output "ebs_id" {

  value = "${data.terraform_remote_state.ebs.ebs_id}"

}

output "public_ip" {

  value = "${aws_instance.imaging-platform-terraform-run-script.public_ip}"

}
