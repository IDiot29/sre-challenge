module "asg_nimbly" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "8.0.0"
  providers = {
    aws = aws.nimbly
  } 

  name = "nimbly-asg"

  min_size                  = 0
  max_size                  = 4
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = slice(data.terraform_remote_state.vpc.outputs.private_subnets_list, 0, 2)
 
  traffic_source_attachments = {
    stocbit-alb = {
      traffic_source_identifier = module.alb_nimbly.target_groups["nimbly_instance"].arn
    }
  }

  # Launch template
  launch_template_name        = "nimbly-asg"
  launch_template_description = "Launch template nimbly"
  update_default_version      = true

  image_id          = "ami-081205ca71b3f3635"
  instance_type     = "t2.micro"
  enable_monitoring = false
  user_data         = filebase64("${path.module}/Scripts/user_data.sh")
  security_groups   = [module.security_nimbly_applications.security_group_id]

  scaling_policies     = {
    avg-cpu-policy-greater-than-80 = {
      policy_type               = "TargetTrackingScaling"
      estimated_instance_warmup = 72
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 80.0
      }
    }
  }

  create_iam_instance_profile = true
  iam_role_name               = "ssm-asg"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role for access to EC2 via SSM"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  block_device_mappings = [
    {
      device_name = "/dev/sda1"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 8
        volume_type           = "gp2"
      }
    }
  ]

  tags = merge(local.nimbly-tags,
  {
    Environment  = "dev"
    CreatedOn    = "21/03/2025"
  })
}
