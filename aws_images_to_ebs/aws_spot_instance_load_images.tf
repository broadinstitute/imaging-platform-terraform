variable "aws_credentials" {}

variable "aws_key_name" {}

variable "github_key" {}

variable "github_pub" {}

variable "instance_type" {}

variable "private_key" {}

variable "script_name" {}

variable "spot_price" {}

variable "vpc_key" {}


data "terraform_remote_state" "vpc" {

  backend ="s3"

  config {

    bucket = "imaging-platform-terraform-remote-backend"

    key = "aws_resources_init/terraform.tfstate"

    region = "${var.region}"

  }

}


resource "aws_spot_instance_request" "imaging-platform-terraform-load-images" {
  ami                     = "${var.ami}"

  associate_public_ip_address = true

  availability_zone       = "${var.availability_zone}"

  connection {

    user                = "ubuntu"

    private_key         = "${file("${var.private_key}")}"

    host                = "${aws_spot_instance_request.imaging-platform-terraform-load-images.public_ip}"

  }

  iam_instance_profile    = "${data.terraform_remote_state.vpc.iam_role_id}"

  instance_type           = "${var.instance_type}"

  key_name                = "${var.aws_key_name}"

  provisioner "file" {

    source = "${var.aws_credentials}"

    destination = "~/.aws/credentials"

  }

  provisioner "file" {

    source = "${var.github_key}"

    destination = "~/.ssh/id_rsa_aws"

  }

  provisioner "file" {

    source = "${var.github_pub}"

    destination = "~/.ssh/id_rsa_aws.pub"

  }

  provisioner "remote-exec" {

    scripts = [

      "${var.script_name}"

      ]

  }

  spot_price              = "${var.spot_price}"

  spot_type               = "one-time"

  subnet_id               = "${data.terraform_remote_state.vpc.subnet_id}"

  tags {

    Name = "imaging-platform-terraform-load-images"

  }

  vpc_security_group_ids  = ["${data.terraform_remote_state.vpc.sg_id}"]

  wait_for_fulfillment    = true

}


resource "aws_volume_attachment" "imaging-platform-terraform-images-att" {

  device_name = "/dev/sdh"

  instance_id = "${aws_spot_instance_request.imaging-platform-terraform-load-images.id}"

  volume_id   = "${aws_ebs_volume.imaging-platform-terraform-images.id}"

}
