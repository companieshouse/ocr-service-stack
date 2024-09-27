locals {
  stack_name                  = "ocr"
  stack_fullname              = "${local.stack_name}-stack"
  name_prefix                 = "${local.stack_name}-${var.environment}"
  global_prefix               = "global-${var.environment}"

  stack_secrets               = jsondecode(data.vault_generic_secret.secrets.data_json)

  application_subnet_pattern  = local.stack_secrets["application_subnet_pattern"]
  application_subnet_ids      = join(",", data.aws_subnets.application.ids)
  kms_key_alias               = local.stack_secrets["kms_key_alias"]
  vpc_name                    = local.stack_secrets["vpc_name"]
  notify_topic_slack_endpoint = local.stack_secrets["notify_topic_slack_endpoint"]

  parameter_store_secrets     = {
    "web-oauth2-cookie-secret" = local.stack_secrets["web-oauth2-cookie-secret"]
  }

  global_secrets_arn_map = {
    for sec in data.aws_ssm_parameter.global_secret :
    trimprefix(sec.name, "/${local.global_prefix}/") => sec.arn
  }

    # get eric secrets from global secrets map
  eric_secrets = [
    { "name": "API_KEY", "valueFrom": local.global_secrets_arn_map.eric_api_key },
    { "name": "AES256_KEY", "valueFrom": local.global_secrets_arn_map.eric_aes256_key }
  ]

  eric_environment_filename = "eric.env"
}
