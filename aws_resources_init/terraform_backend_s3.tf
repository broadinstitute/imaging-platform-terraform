terraform {

  backend "s3" {

    bucket = "${aws_s3_bucket.imaging-platform-terraform-remote-backend.id}"

    key    = "aws_resouces_init/terraform.tfstate"

    region = "${var.region}"

  }

}
