terraform {

  backend "s3" {

    bucket = "imaging-platform-terraform-remote-backend"

    key    = "aws_resouces_init/terraform.tfstate"

    region = "us-east-1"

  }

}
