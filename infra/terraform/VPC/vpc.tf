module "vpc_nimbly" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.15.0"
  providers = {
    aws = aws.nimbly
  }

  name = "vpc-nimbly"
  cidr = "10.10.0.0/16"
  azs              = ["ap-southeast-3a","ap-southeast-3b"]
  private_subnets  = ["10.10.1.0/24", "10.10.2.0/24"]
  public_subnets   = ["10.10.3.0/24", "10.10.4.0/24"]
  database_subnets = ["10.10.5.0/24", "10.10.6.0/24"]
  public_subnet_names  = ["nimbly-subnet-public-3a", "nimbly-subnets-public-3b"]
  private_subnet_names = ["nimbly-subnet-private-3a", "nimbly-subnets-private-3b"]
  database_subnet_names = ["nimbly-subnet-database-3a", "nimbly-subnets-database-3b"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames   = true

  tags = merge(local.nimbly-tags,
  {
    Environment  = "dev"
    CreatedOn    = "21/03/2025"
  })
  private_subnet_tags = {
    Scope = "private"
  }
  public_subnet_tags = {
    Scope = "public"
  }
}
