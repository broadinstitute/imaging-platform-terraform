resource "null_resource" "aws_maxprojection" {

  depends_on = ["module.cp_demo_aws_maxprojection"]

  connection {

    host = "${module.cp_demo_aws_maxprojection.public_ip}"

    private_key = "${file("${var.private_key}")}"

    user = "ubuntu"

  }

  provisioner "file" {

    source = "../als.cfg"

    destination = "~/als.cfg"

  }

  provisioner "remote-exec" {

      inline = [

      "echo ${module.cp_demo_aws_maxprojection.ebs_id} > ~/ebs_id.txt",

      ]

  }

  provisioner "remote-exec" {

    scripts = [

      "max_projection.sh"

    ]

  }

}
