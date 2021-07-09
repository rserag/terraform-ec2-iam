module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "3.0.0"
  name                   = "test-vpc"
  azs                    = ["us-east-1a", "us-east-1b", "us-east-1c"]
  cidr                   = "10.0.0.0/16"
  private_subnets        = ["10.0.1.0/24"]
  public_subnets         = ["10.0.2.0/24"]
  enable_nat_gateway     = true
//  single_nat_gateway     = false
//  one_nat_gateway_per_az = true
  enable_dns_hostnames   = true

  tags = {
    "Terraform managed"  = "true"
    "GithubRepo"         = "terraform-aws-vpc"
    "GithubOrg"          = "terraform-aws-modules"
  }
}
