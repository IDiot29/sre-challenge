module "ecr_nimbly" {
  source = "terraform-aws-modules/ecr/aws"
  version = "2.3.0"
  providers = {
    aws = aws.nimbly
  }

  repository_name = "stocbit-registry"

  repository_read_write_access_arns = ["arn:aws:iam::850995550975:role/ec2/ssm-asg-20241109112359911900000001", "arn:aws:iam::850995550975:user/valdo-admin"]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "any",
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = merge(local.nimbly-tags,
  {
    Environment  = "dev"
    CreatedOn    = "21/03/2025"
  })
}
