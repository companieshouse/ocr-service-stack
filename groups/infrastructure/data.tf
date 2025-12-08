data "aws_caller_identity" "current" {}

data "vault_generic_secret" "secrets" {
  path = "applications/${var.aws_profile}/${var.environment}/${local.stack_fullname}"
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "aws_subnets" "application" {
  filter {
    name   = "tag:Name"
    values = [local.application_subnet_pattern]
  }
}

data "aws_subnet" "application" {
  for_each = toset(data.aws_subnets.application.ids)
  id       = each.value
}

data "aws_subnets" "heritage" {
  provider = aws.heritage

  filter {
    name   = "tag:Name"
    values = [local.heritage_data_subnet_pattern]
  }
}

data "aws_subnet" "heritage" {
  for_each = toset(data.aws_subnets.heritage.ids)
  provider = aws.heritage
  id       = each.value
}

data "aws_subnets" "management" {
  provider = aws.development

  filter {
    name   = "tag:Service"
    values = ["management"]
  }
  filter {
    name   = "tag:NetworkType"
    values = ["private"]
  }

}

data "aws_subnet" "management" {
  for_each = toset(data.aws_subnets.management.ids)
  id       = each.value
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_acm_certificate" "cert" {
  domain = var.cert_domain
}

data "aws_ec2_managed_prefix_list" "admin" {
  name = "administration-cidr-ranges"
}

data "aws_ec2_managed_prefix_list" "shared_services_management" {
  name = "shared-services-management-cidrs"
}
