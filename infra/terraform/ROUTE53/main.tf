module "zones_nimbly" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 4.1.0"

  zones = {
    "rivaldo.ninja" = {
      tags = merge(local.nimbly-tags,
      {
        Name         = "domain.com"
        CreatedOn    = "21/03/2025"
      })
    }
  }

  tags = {
    ManagedBy = "Terraform"
  }
}

module "records_nimbly" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 4.1.0"

  zone_name = keys(module.zones_nimbly.route53_zone_zone_id)[0]

  records = [
    {
      name    = "nimbly-test"
      type    = "CNAME"
      ttl     = 300
      records = ["nimbly-alb-1899064646.ap-southeast-3.elb.amazonaws.com"]
    },
  ]

  depends_on = [module.zones_nimbly]
}
