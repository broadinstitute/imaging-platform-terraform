data "terraform_remote_state" "vpc" {

  backend = "s3"

  config {

    bucket = "imaging-platform-terraform-remote-backend"

    key = "aws_resources_init/terraform.tfstate"

  }

}

resource "aws_spot_instance_request" "imaging-platform-terraform-cellprofiler-demo-load-images" {

  spot_price              = "${var.spot_price}"

  spot_type               = "one-time"

  wait_for_fulfillment    = true

  ami                     = "${var.ami}"

  associate_public_ip_address = true

  availability_zone       = "${var.availability_zone}"

  iam_instance_profile    = "${data.terraform_remote_state.vpc.iam_role_id}"

  instance_type           = "${var.instance_type}"

  key_name                = "${var.aws_key_name}"

  subnet_id               = "${data.terraform_remote_state.vpc.subnet_id}"

  vpc_security_group_ids  = ["${data.terraform_remote_state.vpc.sg_id}"]

  tags {

    Name = "imaging-platform-terraform-cellprofiler-demo-load-images"

  }

  connection {

    user                = "ubuntu"

    private_key         = "${file("${var.private_key}")}"

    host                = "${aws_spot_instance_request.imaging-platform-terraform-cellprofiler-demo-load-images.public_ip}"

  }

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

      "load_images.sh"

      ]

  }

}

resource "aws_volume_attachment" "imaging-platform-terraform-cellprofiler-demo-att" {

  device_name = "/dev/bucket"

  instance_id = "${aws_spot_instance_request.imaging-platform-terraform-cellprofiler-demo.id}"

  volume_id   = "${aws_ebs_volume.imaging-platform-terraform-cellprofiler-demo.id}"

}