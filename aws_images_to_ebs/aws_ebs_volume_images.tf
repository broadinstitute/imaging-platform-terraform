resource "aws_ebs_volume" "imaging-platform-terraform-images" {

  availability_zone = "${data.terraform_remote_state.vpc.subnet_availability_zone}"

  size              = "${var.size}"

  tags = {

    Name = "imaging-platform-terraform-images"

  }

}
