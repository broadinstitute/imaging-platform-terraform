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

      inline = [

      "echo ${module.cp_demo_illum_decay.ebs_id} > ~/ebs_id.txt",

      ]

  }

  provisioner "remote-exec" {

    scripts = [

      "illum.sh"

    ]

  }

}
