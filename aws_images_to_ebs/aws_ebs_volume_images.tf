variable "availability_zone" {}

variable "size" {}

resource "aws_ebs_volume" "imaging-platform-terraform-images" {

  availability_zone = "${var.availability_zone}"

  size              = "${var.size}"

  tags = {

    Name = "imaging-platform-terraform-images"

  }

}
