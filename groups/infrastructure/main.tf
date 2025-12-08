terraform {
  required_version = ">= 1.3, < 2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
       version = ">= 5.0, < 6.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 4.0, < 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
}

provider "aws" {
  alias  = "eu-west-1"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "heritage"
  region = "eu-west-2"

  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids[var.heritage_account]}:role/${data.aws_caller_identity.current.account_id}-terraform-lookup"
  }
}

terraform {
  backend "s3" {}
}

module "ecs-cluster" {
  source = "git@github.com:companieshouse/terraform-modules//aws/ecs/ecs-cluster?ref=1.0.361"

  stack_name                  = local.stack_name
  name_prefix                 = local.name_prefix
  environment                 = var.environment
  aws_profile                 = var.aws_profile
  vpc_id                      = data.aws_vpc.vpc.id
  subnet_ids                  = local.application_subnet_ids
  ec2_instance_type           = var.ec2_instance_type
  asg_max_instance_count      = var.asg_max_instance_count
  asg_min_instance_count      = var.asg_min_instance_count
  enable_container_insights   = var.enable_container_insights
  asg_desired_instance_count  = var.asg_desired_instance_count
  scaledown_schedule          = var.asg_scaledown_schedule
  scaleup_schedule            = var.asg_scaleup_schedule
  enable_asg_autoscaling      = var.enable_asg_autoscaling
  notify_topic_slack_endpoint = local.notify_topic_slack_endpoint
}

module "ocr-api-alb" {
  source = "git@github.com:companieshouse/terraform-modules//aws/application_load_balancer?ref=1.0.361"

  environment             = var.environment
  service                 = "ocr-api"
  ssl_certificate_arn     = data.aws_acm_certificate.cert.arn
  subnet_ids              = split(",", local.application_subnet_ids)
  vpc_id                  = data.aws_vpc.vpc.id
  idle_timeout            = 1200
  create_security_group   = true
  ingress_cidrs           = local.lb_ingress_cidrs
  ingress_prefix_list_ids = local.ingress_prefix_list_ids
  internal                = true
  redirect_http_to_https  = true
  route53_domain_name     = var.domain_name
  route53_aliases         = var.route53_aliases_ocr_api
  create_route53_aliases  = var.create_route53_aliases
  service_configuration = {
    listener_config = {
      default_action_type = "fixed-response"
      port                = 443
    }
  }
}
