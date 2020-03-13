# terraform-polkadot-azure-network

[![open-issues](https://img.shields.io/github/issues-raw/shinyfoil/terraform-polkadot-azure-network?style=for-the-badge)](https://github.com/shinyfoil/terraform-polkadot-azure-network/issues)
[![open-pr](https://img.shields.io/github/issues-pr-raw/shinyfoil/terraform-polkadot-azure-network?style=for-the-badge)](https://github.com/shinyfoil/terraform-polkadot-azure-network/pulls)

## Features

This module...

## Terraform Versions

For Terraform v0.12.0+

## Usage

```
module "this" {
    source = "github.com/shinyfoil/terraform-polkadot-azure-network"

}
```
## Examples

- [defaults](https://github.com/shinyfoil/terraform-polkadot-azure-network/tree/master/examples/defaults)

## Known  Issues
No issue is creating limit on this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| azure\_resource\_group\_name | Name of Azure Resource Group | `string` | n/a | yes |
| cidr | The cidr range for network | `string` | `"10.0.0.0/16"` | no |
| environment | The environment | `string` | `""` | no |
| namespace | The namespace to deploy into | `string` | `""` | no |
| network\_name | The network name, ie kusama / mainnet | `string` | `""` | no |
| owner | n/a | `string` | `""` | no |
| stage | The stage of the deployment | `string` | `""` | no |
| vpc\_name | The name of the VPC | `string` | `"polkadot"` | no |

## Outputs

No output.

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