########
# Label
########
variable "environment" {
  description = "The environment"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "The namespace to deploy into"
  type        = string
  default     = ""
}

variable "stage" {
  description = "The stage of the deployment"
  type        = string
  default     = ""
}

variable "network_name" {
  description = "The network name, ie kusama / mainnet"
  type        = string
  default     = ""
}

variable "owner" {
  type    = string
  default = ""
}

########
# Azure
########

variable "azure_resource_group_name" {
  description = "Name of Azure Resource Group"
  type        = string
}

######
# VPC
######
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "polkadot"
}

variable "cidr" {
  description = "The cidr range for network"
  type        = string
  default     = "10.0.0.0/16"
}