resource "tls_private_key" "admin-key" {
  algorithm               = "RSA"
}

module "key_pair" {
  source                  = "terraform-aws-modules/key-pair/aws"
  version                 = "0.6.0"
  key_name                = "test-admin"
  public_key              = tls_private_key.admin-key.public_key_openssh
}


module "bastion" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "2.19.0"
  name                        = "test-bastion"
  instance_count              = 1
  ami                         = "ami-042e8287309f5df03"
  instance_type               = "t2.small"
  key_name                    = module.key_pair.this_key_pair_key_name
  monitoring                  = false
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.bastion_security_group.this_security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  user_data_base64            = base64encode(local.user_data)
  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp2"
      volume_size = 40
      encrypted   = true
    }
  ]

  tags = {
    "Environment"       = terraform.workspace
    "GithubRepo"        = "ec2-instance/aws"
    "GithubOrg"         = "terraform-aws-modules"
    "Terraform managed" = "true"
  }
  depends_on = [
    module.key_pair
  ]
}

locals {
  user_data = <<EOF
#!/bin/bash
apt update && apt upgrade -y && apt install -y ssh ec2-instance-connect && cp /etc/ssh/sshd_config /etc/ssh/sshd_config.original
cat >/etc/ssh/sshd_config <<EOL
Include /etc/ssh/sshd_config.d/*.conf
#PermitRootLogin prohibit-password
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
ClientAliveInterval 120
ClientAliveCountMax 720
AcceptEnv LANG LC_*
Subsystem       sftp    /usr/lib/openssh/sftp-server
EOL
EOF
}

resource "local_file" "private_key" {
  content  = tls_private_key.admin-key.private_key_pem
  filename = "test-private-key.pem"
}
