terraform {

  backend "s3" {

    bucket = "imaging-platform-terraform-remote-backend"

    key    = "cellprofiler_demo/aws_ebs_volume/terraform.tfstate"

    region = "us-east-1"

  }

}
