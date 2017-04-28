terraform {

  backend "s3" {

    bucket = "imaging-platform-terraform-remote-backend"

    key    = "cellprofiler_dedicated_demo/aws_images_to_ebs/terraform.tfstate"

    region = "us-east-1"

  }

}
