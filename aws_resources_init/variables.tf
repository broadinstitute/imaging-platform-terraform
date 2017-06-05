variable "var_vpc_id" {}

variable "availability_zone" {

  default = "us-east-1a"

}

variable "private_key" {

  default = "C:/Users/karhohs/Dropbox/AWS_credentials/karhohsbroadinstituteorg.pem"

}

variable "region"{

  default = "us-east-1"

}

variable "vpc_id"{

  default = "${var.var_vpc_key}"

}
