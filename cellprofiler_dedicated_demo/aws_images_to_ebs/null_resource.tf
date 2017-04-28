resource "null_resource" "load_images" {

  depends_on = ["module.cp_demo_aws_images_to_ebs"]

  connection {

    host = "${module.cp_demo_aws_images_to_ebs.public_ip}"

    private_key = "${var.private_key}"

    user = "ubuntu"

  }

  provisioner "remote-exec" {
    inline = [
      "/usr/bin/sudo /usr/bin/chown core:core /mnt"
    ]
  }

  provisioner "file" {
    source = "${path.module}/../docker-compose.yml"
    destination = "/mnt/"
  }

  provisioner "file" {
    source = "${path.module}/../services"
    destination = "/mnt"
  }

}
