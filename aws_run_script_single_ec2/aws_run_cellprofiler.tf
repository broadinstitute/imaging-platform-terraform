data "terraform_remote_state" "vpc" {

  backend ="s3"

  config {

    bucket  = "imaging-platform-terraform-remote-backend"

    key     = "${var.vpc_key}"

    region  = "${var.region}"

  }

}

data "terraform_remote_state" "ebs" {

  backend ="s3"

  config {

    bucket  = "imaging-platform-terraform-remote-backend"

    key     = "${var.ebs_key}"

    region  = "${var.region}"

  }

}

resource "aws_instance" "imaging-platform-terraform-run-script-single-ec2" {

  ami                     = "${var.ami}"

  associate_public_ip_address = true

  availability_zone       = "${data.terraform_remote_state.vpc.subnet_availability_zone}"

  connection {

    host                = "${aws_instance.imaging-platform-terraform-run-script-single-ec2.public_ip}"

    private_key         = "${file("${var.private_key}")}"

    user                = "ubuntu"

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

  root_block_device {

    volume_size           = "${var.root_block_device_volume_size}"

  }

  subnet_id               = "${data.terraform_remote_state.vpc.subnet_id}"

  tags {

    Name = "imaging-platform-terraform-run-script-single-ec2"

  }

  vpc_security_group_ids  = ["${data.terraform_remote_state.vpc.sg_id}"]

}
