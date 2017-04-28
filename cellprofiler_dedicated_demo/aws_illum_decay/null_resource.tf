resource "null_resource" "load_images" {

  depends_on = ["module.cp_demo_illum_decay"]

  connection {

    host = "${module.cp_demo_illum_decay.public_ip}"

    private_key = "${file("${var.private_key}")}"

    user = "ubuntu"

  }

  provisioner "file" {

    source = "../als.cfg"

    destination = "~/als.cfg"

  }

  provisioner "remote-exec" {

    scripts = [

      "illum.sh"

    ]

  }

  provisioner "remote-exec" {

      inline = [

      "source /home/ubuntu/.profile",

      "source activate awscli",

      "echo ${module.cp_demo_aws_images_to_ebs.ebs_id}",

      "aws ec2 detach-volume --volume-id ${module.cp_demo_aws_images_to_ebs.ebs_id}",

      "source deactivate awscli"

      ]

  }

}
