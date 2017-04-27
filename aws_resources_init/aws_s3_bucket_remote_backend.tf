resource "aws_s3_bucket" "imaging-platform-terraform-remote-backend"{

  bucket = "imaging-platform-terraform-remote-backend"

  lifecycle {

    prevent_destroy = true

  }

  tags {

      Name = "imaging-platform-terraform-remote-backend"

  }

}
