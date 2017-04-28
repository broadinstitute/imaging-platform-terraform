resource "null_resource" "load_images" {

  depends_on = ["module.cp_demo_aws_images_to_ebs"]

  connection {

    host = "${module.cp_demo_aws_images_to_ebs.public_ip}"

    private_key = "${file("${var.private_key}")}"

    user = "ubuntu"

  }

  provisioner "remote-exec" {

    scripts = [

      "load_images.sh"

    ]

  }

}
