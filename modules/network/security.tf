##########
# Security group
######

resource "aws_security_group" "my_sql_db" {
  name        = "mochi-${var.infra_env}-my_sql_db_sg"
  description = "security group for mysql"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name        = "mochi-${var.infra_env}-my_sql_db_sg"
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }

}

resource "aws_security_group_rule" "my_sql_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.my_sql_db.id

  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = [module.vpc.vpc_cidr_block]
}

resource "aws_security_group_rule" "my_sql_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.my_sql_db.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_security_group" "public" {
  name        = "mochi-${var.infra_env}-public"
  description = "security group for public "
  vpc_id      = module.vpc.vpc_id

  ingress {
    cidr_blocks = [module.vpc.vpc_cidr_block]
    description = "all traffic "
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
  }
  tags = {
    Name        = "mochi-${var.infra_env}-public"
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }

}



resource "aws_ssm_parameter" "sg_ids" {
  name        = "security_group_ids"
  description = "sqids to connect to  database"
  type        = "StringList"
  value       = aws_security_group.my_sql_db.id
}