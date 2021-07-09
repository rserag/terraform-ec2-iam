module "bastion_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"

  name        = "bastion-sg"
  description = "Complete Bastion security group"
  vpc_id      = module.vpc.vpc_id

  # Ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH SFL Office"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  # Egress
  egress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      description = "Egress route"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = {
    "GithubRepo"          = "terraform-aws-security-group"
    "GithubOrg"           = "terraform-aws-modules"
    "Terraform managed"   = "true"
  }

  depends_on = [
    module.vpc
  ]
}
