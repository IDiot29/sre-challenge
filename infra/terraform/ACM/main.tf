module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 5.1.1"

  domain_name  = "domain.com"
  zone_id      = ""

  validation_method = "DNS"

  subject_alternative_names = [
    "*.domain.com",
  ]

  wait_for_validation = true

  tags = merge(local.nimbly-tags,
  {
    Name         = "domain.com"
    CreatedOn    = "21/03/2025"
  })
}
