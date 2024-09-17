data "vault_generic_secret" "secrets" {
  path = "applications/${var.aws_profile}/${var.environment}/${local.stack_fullname}"
}

data "aws_kms_key" "stack_configs" {
  key_id = "alias/${var.aws_profile}/${local.kms_key_alias}"
}

data "aws_subnets" "application" {
  filter {
    name   = "tag:Name"
    values = [local.application_subnet_pattern]
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_ami" "ecs" {
  name_regex  = var.ec2_ami_name_regex
  most_recent = true
  owners      = var.ec2_ami_owners
}
