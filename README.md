# terraform-polkadot-azure-network

[![open-issues](https://img.shields.io/github/issues-raw/insight-w3f/terraform-polkadot-azure-network?style=for-the-badge)](https://github.com/insight-w3f/terraform-polkadot-azure-network/issues)
[![open-pr](https://img.shields.io/github/issues-pr-raw/insight-w3f/terraform-polkadot-azure-network?style=for-the-badge)](https://github.com/insight-w3f/terraform-polkadot-azure-network/pulls)

## Features

This module...

## Terraform Versions

For Terraform v0.12.0+

## Usage

```
resource "azurerm_resource_group" "this" {
  location = "eastus"
  name     = "asg-default-testing"
}

module "defaults" {
  source                    = "../.."
  azure_resource_group_name = azurerm_resource_group.this.name
}
```

## Examples

- [defaults](https://github.com/insight-w3f/terraform-polkadot-azure-network/tree/master/examples/defaults)

## Known  Issues
No issue is creating limit on this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |
| cloudflare | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| azure\_resource\_group\_name | Name of Azure Resource Group | `string` | n/a | yes |
| bastion\_enabled | Boolean to enable a bastion host.  All ssh traffic restricted to bastion | `bool` | `false` | no |
| bastion\_sg\_name | Name for the bastion security group | `string` | `"bastion-sg"` | no |
| cidr | The cidr range for network | `string` | `"172.16.0.0/16"` | no |
| consul\_enabled | Boolean to allow consul traffic | `bool` | `false` | no |
| consul\_sg\_name | Name for the consult security group | `string` | `"consul-sg"` | no |
| corporate\_ip | The corporate IP you want to restrict ssh traffic to | `string` | `""` | no |
| create\_internal\_domain | Boolean to create an internal split horizon DNS | `bool` | `false` | no |
| create\_public\_regional\_subdomain | Boolean to create regional subdomain - ie us-east-1.example.com | `bool` | `false` | no |
| hids\_enabled | Boolean to enable intrusion detection systems traffic | `bool` | `false` | no |
| hids\_sg\_name | Name for the HIDS security group | `string` | `"hids-sg"` | no |
| internal\_tld | The top level domain for the internal DNS | `string` | `"internal"` | no |
| logging\_enabled | Boolean to allow logging related traffic | `bool` | `false` | no |
| logging\_sg\_name | Name for the logging security group | `string` | `"logging-sg"` | no |
| monitoring\_enabled | Boolean to for prometheus related traffic | `bool` | `false` | no |
| monitoring\_sg\_name | Name for the monitoring security group | `string` | `"monitoring-sg"` | no |
| namespace | The namespace to deploy into | `string` | `"polkadot"` | no |
| network\_name | The network name, ie kusama / mainnet | `string` | `""` | no |
| owner | n/a | `string` | `""` | no |
| root\_domain\_name | The public domain | `string` | `""` | no |
| sentry\_node\_sg\_name | Name for the public node security group | `string` | `"sentry-sg"` | no |
| tags | Key value pair to tag all resources | `map(string)` | `{}` | no |
| vault\_enabled | Boolean to allow vault related traffic | `bool` | `false` | no |
| vault\_sg\_name | Name for the vault security group | `string` | `"vault-sg"` | no |
| vpc\_name | The name of the VPC | `string` | `"polkadot"` | no |
| zone\_id | The zone ID to configure as the root zone - ie subdomain.example.com's zone ID | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_application\_security\_group\_id | Name of the application security group for the bastion host |
| bastion\_network\_security\_group\_id | Name of the network security group for the bastion host |
| consul\_application\_security\_group\_id | Name of the application security group for the Consul servers |
| hids\_application\_security\_group\_id | Name of the application security group for the HIDS group |
| internal\_tld | The name of the internal domain |
| logging\_application\_security\_group\_id | Name of the application security group for the logging group |
| monitoring\_application\_security\_group\_id | Name of the application security group for the monitoring group |
| private\_network\_security\_group\_id | Name of the private subnet network security group |
| private\_subnets | The IDs of the private subnets |
| private\_subnets\_cidr\_blocks | CIDR ranges for the private subnets |
| public\_network\_security\_group\_id | Name of the public subnet network security group |
| public\_regional\_domain | The public regional domain |
| public\_subnet\_cidr\_blocks | CIDR ranges for the public subnets |
| public\_subnets | The IDs of the public subnets |
| root\_domain\_name | The name of the root domain |
| sentry\_application\_security\_group\_id | Name of the application security group for the sentry group |
| vault\_application\_security\_group\_id | Name of the application security group for the vault group |
| vpc\_id | The name of the VPC |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Testing
This module has been packaged with terratest tests

To run them:

1. Install Go
2. Run `make test-init` from the root of this repo
3. Run `make test` again from root

## Authors

Module managed by [Richard Mah](https://github.com/shinyfoil)

## Credits

- [Anton Babenko](https://github.com/antonbabenko)

## License

Apache 2 Licensed. See LICENSE for full details.