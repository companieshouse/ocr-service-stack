locals {
  stack_name     = "utility-services"
  stack_fullname = "${local.stack_name}-stack"
  name_prefix    = "${local.stack_name}-${var.environment}"

  stack_secrets              = jsondecode(data.vault_generic_secret.secrets.data_json)

  application_subnet_pattern = local.stack_secrets["application_subnet_pattern"]
  application_subnet_ids     = join(",", data.aws_subnets.application.ids)
  kms_key_alias              = local.stack_secrets["kms_key_alias"]
  vpc_name                   = local.stack_secrets["vpc_name"]
  notify_topic_slack_endpoint = local.stack_secrets["notify_topic_slack_endpoint"]

  ec2_ami_id = var.ec2_ami_id == "" ? data.aws_ami.ecs.id : var.ec2_ami_id

  parameter_store_secrets    = {
    "web-oauth2-cookie-secret" = local.stack_secrets["web-oauth2-cookie-secret"]
  }
}
