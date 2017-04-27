module "cp_demo_aws_images_to_ebs" {

  aws_credentials = "C:/Users/karhohs/Dropbox/AWS_credentials/credentials"

  aws_key_name = "karhohs@broadinstitute.org"

  github_key = "C:/Users/karhohs/Dropbox/AWS_credentials/id_rsa_aws"

  github_pub = "C:/Users/karhohs/Dropbox/AWS_credentials/id_rsa_aws.pub"

  private_key = "C:/Users/karhohs/Dropbox/AWS_credentials/karhohsbroadinstituteorg.pem"

  script_name = "load_images.sh"

  size = "100"

  source = "github.com/broadinstitute/imaging-platform-terraform/aws_images_to_ebs"

  vpc_key = "aws_resources_init/terraform.tfstate"

}
