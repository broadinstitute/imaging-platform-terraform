variable "cidr_block" {}

variable "vpc_id" {}

resource "aws_subnet" "imaging-platform-terraform-cellprofiler" {

  cidr_block = "${var.cidr_block}"

  map_public_ip_on_launch = true

  tags {

      Name = "imaging-platform-terraform-cellprofiler"
      
  }

    vpc_id = "${var.vpc_id}"

}
