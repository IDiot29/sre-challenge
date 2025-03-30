module "alb_nimbly" {
  source = "terraform-aws-modules/alb/aws"
  version = "9.12.0"
  providers = {
    aws = aws.nimbly
  }

  name    = "nimbly-alb"
  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets = slice(data.terraform_remote_state.vpc.outputs.public_subnets_list, 0, 2)
  security_groups = [module.security_group_nimbly_alb.security_group_id]


  listeners = {
    http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    https = {
      port               = 443
      protocol           = "HTTPS"
      ssl_policy         = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
      certificate_arn    = "arn:aws:acm:ap-southeast-3:850995550975:certificate/a0a615a9-71d2-4db1-b14d-f8fb22ad5c7d"

      action_type = "fixed-response"
      fixed_response = {
          status_code  = "401"
          content_type = "text/plain"
          message_body = "OK"
      }
      rules = {
        nimbly-instance = {
          priority = 1
          actions = [
            {
              type             = "forward"
              target_group_key = "nimbly_instance"
            }
          ]
          conditions = [
            {
              host_header = {
                values = ["nimbly-test.rivaldo.ninja"]
              }
            }
          ]
        }
      }
    }
  }

  target_groups = {
    nimbly_instance = {
      name_prefix                       = "vl"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        path                = "/"
        protocol            = "HTTP"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        interval            = 30
        matcher             = "200-499"
      }
      create_attachment = false
    }
  }

  tags = merge(local.nimbly-tags,
  {
    Environment  = "dev"
    CreatedOn    = "21/03/2025"
  })
}
