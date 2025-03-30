module "security_group_nimbly_alb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"
  providers = {
    aws = aws.nimbly
  }

  name                = "nimbly-alb-sg"
  description         = "Security group for load balancer"
  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]

  tags = merge(local.nimbly-tags,
  {
    Environment  = "dev"
    CreatedOn    = "21/03/2025"
  })
}

module "security_nimbly_applications" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"
  providers = {
    aws = aws.nimbly
  }

  name                = "nimbly-applications-sg"
  description         = "Security group for applications"
  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "10.10.0.0/16"
    }
  ]

  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]

  tags = merge(local.nimbly-tags,
  {
    Environment  = "dev"
    CreatedOn    = "21/03/2025"
  })
}
