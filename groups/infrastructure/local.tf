locals {
  stack_name                  = "ocr"
  stack_fullname              = "${local.stack_name}-stack"
  name_prefix                 = "${local.stack_name}-${var.environment}"

  stack_secrets               = jsondecode(data.vault_generic_secret.secrets.data_json)

  application_subnet_pattern  = local.stack_secrets["application_subnet_pattern"]
  application_subnet_ids      = join(",", data.aws_subnets.application.ids)

  vpc_name                    = local.stack_secrets["vpc_name"]
  notify_topic_slack_endpoint = local.stack_secrets["notify_topic_slack_endpoint"]

  application_cidrs       = [for subnet in data.aws_subnet.application : subnet.cidr_block]
  ingress_prefix_list_ids = [data.aws_ec2_managed_prefix_list.admin.id, data.aws_ec2_managed_prefix_list.shared_services_management.id]

  account_ids                             = data.vault_generic_secret.account_ids.data
  heritage_application_subnet_pattern     = local.stack_secrets["heritage_application_subnet_pattern"]
  heritage_data_cidrs                     = [for subnet in data.aws_subnet.heritage : subnet.cidr_block]
  management_private_subnet_cidrs         = [for subnet in data.aws_subnet.management : subnet.cidr_block]
  lb_ingress_cidrs                        = concat(local.application_cidrs, local.management_private_subnet_cidrs, local.heritage_data_cidrs)

}
