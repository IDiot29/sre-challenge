output "vpc_id" {
  description = "Get of vpc_id"
  value       = module.vpc_nimbly.vpc_id
}

output "private_subnets_list" {
  description = "List of private_subnets_list"
  value       = module.vpc_nimbly.private_subnets
}

output "public_subnets_list" {
  description = "List of public_subnets_list"
  value       = module.vpc_nimbly.public_subnets
}

output "database_subnets_list" {
  description = "List of public_subnets_list"
  value       = module.vpc_nimbly.database_subnets
}
