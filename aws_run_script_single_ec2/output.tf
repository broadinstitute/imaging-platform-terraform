output "public_ip" {

  value = "${aws_instance.imaging-platform-terraform-run-script.public_ip}"

}
