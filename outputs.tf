#####
# SGs
#####
output "bastion_security_group_id" {
  value       = azurerm_application_security_group.bastion_asg.*.name
  description = "Name of the application security group for the bastion host"
}

output "consul_security_group_id" {
  value       = azurerm_application_security_group.consul_asg.*.name
  description = "Name of the application security group for the Consul servers"
}

output "hids_security_group_id" {
  value       = azurerm_application_security_group.hids_asg.*.name
  description = "Name of the application security group for the HIDS group"
}

output "logging_security_group_id" {
  value       = azurerm_application_security_group.consul_asg.*.name
  description = "Name of the application security group for the logging group"
}

output "monitoring_security_group_id" {
  value       = azurerm_application_security_group.monitoring_asg.*.name
  description = "Name of the application security group for the monitoring group"
}

output "sentry_security_group_id" {
  value       = azurerm_application_security_group.sentry_node_asg.*.name
  description = "Name of the application security group for the sentry group"
}

output "vault_security_group_id" {
  value       = azurerm_application_security_group.vault_asg.*.name
  description = "Name of the application security group for the vault group"
}

#####
# VPC
#####

output "asdf" {
  value = azurerm_subnet.public.*.name
}

output "vpc_id" {
  value       = azurerm_virtual_network.vpc_network.name
  description = "The name of the VPC"
}

output "public_subnets" {
  value       = azurerm_subnet.public.*.name
  description = "The IDs of the public subnets"
}

output "private_subnets" {
  value       = azurerm_subnet.private.*.name
  description = "The IDs of the private subnets"
}

output "public_subnet_cidr_blocks" {
  value       = local.public_subnets[*]
  description = "CIDR ranges for the public subnets"
}

output "private_subnets_cidr_blocks" {
  value       = local.private_subnets[*]
  description = "CIDR ranges for the private subnets"
}
