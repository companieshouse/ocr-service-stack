# Environment
variable "environment" {
  type        = string
  description = "The environment name, defined in envrionments vars."
}
variable "aws_region" {
  default     = "eu-west-2"
  type        = string
  description = "The AWS region for deployment."
}
variable "aws_profile" {
  default     = "development-eu-west-2"
  type        = string
  description = "The AWS profile to use for deployment."
}

# EC2
variable "ec2_key_pair_name" {
  type        = string
  description = "The key pair for SSH access to ec2 instances in the clusters."
}
variable "ec2_instance_type" {
  default     = "m7i.xlarge"
  type        = string
  description = "The instance type for ec2 instances in the clusters."
}

# Auto-scaling Group
variable "asg_max_instance_count" {
  default     = 0
  type        = number
  description = "The maximum allowed number of instances in the autoscaling group for the cluster."
}
variable "asg_min_instance_count" {
  default     = 0
  type        = number
  description = "The minimum allowed number of instances in the autoscaling group for the cluster."
}
variable "asg_desired_instance_count" {
  default     = 0
  type        = number
  description = "The desired number of instances in the autoscaling group for the cluster. Must fall within the min/max instance count range."
}

variable "asg_scaledown_schedule" {
  default     = ""
  type        = string
  description = "The schedule to use when scaling down the number of EC2 instances to zero."
}

variable "asg_scaleup_schedule" {
  default     = ""
  type        = string
  description = "The schedule to use when scaling up the number of EC2 instances to their normal desired level."
}

variable "enable_asg_autoscaling" {
  default     = true
  type        = bool
  description = "Whether to enable auto-scaling of the ASG by creating a capacity provider for the ECS cluster."
}

variable "ec2_ami_id" {
  default     = ""
  description = "The AMI id to use when launching instances in the ASG; when set, will be preferred over the result of an AMI lookup"
  type        = string
}

variable "ec2_ami_name_regex" {
  default     = "^al2023-ami-ecs-hvm-2023.0.*-kernel-6.1-x86_64"
  description = "The regex pattern to use to lookup an AMI, when ec2_ami_id is empty"
  type        = string
}

variable "ec2_ami_owners" {
  default     = ["amazon"]
  description = "A list of AWS marketplace AMI owners used to filter the AMI lookup, when ec2_ami_id is empty"
  type        = list(string)
}

# Container Insights - ECS
variable "enable_container_insights" {
  type        = bool
  description = "A boolean value indicating whether to enable Container Insights or not"
  default     = true
}
