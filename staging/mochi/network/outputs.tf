output "vpc_id" {
  value = module.vpc.vpc_id

}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr

}

output "vpc_azs" {
  value = module.vpc.vpc_azs
}

output "vpc_public_subnets" {
  value = module.vpc.vpc_public_subnets


}

output "security_group_mysql_id" {
  value = module.vpc.security_group_mysql_id

}

output "security_group_public" {
  value = module.vpc.security_group_public

}
