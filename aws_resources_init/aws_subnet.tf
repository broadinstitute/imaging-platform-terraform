resource "aws_subnet" "imaging-platform-terraform-cellprofiler" {

  cidr_block = "10.0.9.0/24"

  map_public_ip_on_launch = true

  tags {
      Name = "imaging-platform-terraform-cellprofiler"
  }

    vpc_id = "${var.vpc_id}"

}
