output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}

output "vpc_azs" {
  value = module.vpc.azs
}

output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}

output "security_group_mysql_id" {
  value = aws_security_group.my_sql_db.id
}

output "security_group_public" {
  value = aws_security_group.public.id
}