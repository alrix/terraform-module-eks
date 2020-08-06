# Inherited
variable "cluster_name" {
  description = "Name of the EKS Cluster"
}
variable "vpc_id" {
  description = "VPC in which to deploy the EKS Cluster"
}

variable "subnet_identifier" {
  description = "value of Tag:role to identify which subnets to deploy into"
  default = "eks"
}

# Variables with defaults assigned
variable eks_cluster_version { default = "1.17" }

# Cluster logging for cloudwatch
variable cluster_log_types { default = "api,audit,authenticator,controllerManager,scheduler" }

# Cloudwatch 
variable retention_in_days { default = "7" }
