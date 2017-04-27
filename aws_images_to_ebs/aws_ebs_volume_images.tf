variable "size" {}

resource "aws_ebs_volume" "imaging-platform-terraform-images" {

  size = "${var.size}"

  tags = {

    Name = "imaging-platform-terraform-images"

  }

}
