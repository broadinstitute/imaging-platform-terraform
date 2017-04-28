terraform {

  backend "s3" {

    bucket = "imaging-platform-terraform-remote-backend"

    key    = "cellprofiler_dedicated_demo/aws_maxprojection/terraform.tfstate"

    region = "us-east-1"

  }

}
