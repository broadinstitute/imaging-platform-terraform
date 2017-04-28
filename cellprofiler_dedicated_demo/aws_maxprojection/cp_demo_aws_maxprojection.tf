module "cp_demo_aws_maxprojection" {

  aws_credentials = "C:/Users/karhohs/Dropbox/AWS_credentials/credentials"

  aws_key_name = "karhohs@broadinstitute.org"

  ebs_key = "cellprofiler_dedicated_demo/aws_images_to_ebs/terraform.tfstate"

  github_key = "C:/Users/karhohs/Dropbox/AWS_credentials/id_rsa_aws"

  github_pub = "C:/Users/karhohs/Dropbox/AWS_credentials/id_rsa_aws.pub"

  instance_type = "m4.16xlarge"

  private_key = "C:/Users/karhohs/Dropbox/AWS_credentials/karhohsbroadinstituteorg.pem"

  source = "github.com/broadinstitute/imaging-platform-terraform/aws_run_script"

  vpc_key = "aws_resources_init/terraform.tfstate"

}
