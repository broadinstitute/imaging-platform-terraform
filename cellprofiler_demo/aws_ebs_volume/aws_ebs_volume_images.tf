variable "size" {}

resource "aws_ebs_volume" "imaging-platform-terraform-cellprofiler-demo" {

  size = "${var.memory}"

  tags = {

    Name = "imaging-platform-terraform-cellprofiler-demo"

  }

}
