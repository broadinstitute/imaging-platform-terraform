output "ebs_id" {

  value = "${aws_ebs_volume.imaging-platform-terraform-images.id}"

}

output "id" {

  value = "${aws_instance.imaging-platform-terraform-load-images.id}"

}

output "public_ip" {

  value = "${aws_instance.imaging-platform-terraform-load-images.public_ip}"

}
