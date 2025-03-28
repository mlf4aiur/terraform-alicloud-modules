# Alicloud VPC Terraform module

Terraform module which creates VPC resources on Alicloud.


## Usage

```hcl
module "vpc" {
  source = "./vpc"

  name               = "example"
  cidr               = "10.10.0.0/16"
  availability_zones = ["cn-beijing-f", "cn-beijing-b", "cn-beijing-c"]
  public_vswitches   = ["10.10.0.0/22", "10.10.4.0/22", "10.10.8.0/22"]
  private_vswitches  = ["10.10.32.0/20", "10.10.48.0/20", "10.10.64.0/20"]
  pod_vswitches      = ["10.10.128.0/19", "10.10.160.0/19", "10.10.192.0/19"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.239 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.239 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_eip.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/eip) | resource |
| [alicloud_eip_association.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/eip_association) | resource |
| [alicloud_nat_gateway.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/nat_gateway) | resource |
| [alicloud_snat_entry.pod](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/snat_entry) | resource |
| [alicloud_snat_entry.private](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/snat_entry) | resource |
| [alicloud_vpc.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.pod](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_vswitch.private](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_vswitch.public](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | A list of availability zones names or ids in the region | `list(string)` | `[]` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id` | `string` | `"10.0.0.0/16"` | no |
| <a name="input_create_pod_nat_gateway_route"></a> [create\_pod\_nat\_gateway\_route](#input\_create\_pod\_nat\_gateway\_route) | Controls if a nat gateway route should be created to give internet access to the pod vswitches | `bool` | `true` | no |
| <a name="input_create_private_nat_gateway_route"></a> [create\_private\_nat\_gateway\_route](#input\_create\_private\_nat\_gateway\_route) | Controls if a nat gateway route should be created to give internet access to the private vswitches | `bool` | `true` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Controls if VPC should be created (it affects almost all resources) | `bool` | `true` | no |
| <a name="input_eip_bandwidth"></a> [eip\_bandwidth](#input\_eip\_bandwidth) | The eip bandwidth. | `number` | `200` | no |
| <a name="input_eip_internet_charge_type"></a> [eip\_internet\_charge\_type](#input\_eip\_internet\_charge\_type) | Internet charge type of the EIP, Valid values are `PayByBandwidth`, `PayByTraffic`. | `string` | `"PayByTraffic"` | no |
| <a name="input_eip_name"></a> [eip\_name](#input\_eip\_name) | The name prefix used to launch the eip. | `string` | `""` | no |
| <a name="input_eip_payment_type"></a> [eip\_payment\_type](#input\_eip\_payment\_type) | The billing method of the NAT gateway. | `string` | `"PayAsYouGo"` | no |
| <a name="input_eip_period"></a> [eip\_period](#input\_eip\_period) | The duration that you will buy the EIP, in month. | `number` | `1` | no |
| <a name="input_eip_tags"></a> [eip\_tags](#input\_eip\_tags) | The tags used to launch the eip. | `map(string)` | `{}` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Should be true if you want to provision NAT Gateways for each of your private networks | `bool` | `false` | no |
| <a name="input_external_nat_ip_ids"></a> [external\_nat\_ip\_ids](#input\_external\_nat\_ip\_ids) | List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse\_nat\_ips) | `list(string)` | `[]` | no |
| <a name="input_external_nat_ips"></a> [external\_nat\_ips](#input\_external\_nat\_ips) | List of EIP IPs to be assigned to the NAT Gateways (used in combination with reuse\_nat\_ips) | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | `""` | no |
| <a name="input_nat_gateway_name"></a> [nat\_gateway\_name](#input\_nat\_gateway\_name) | The name prefix used to launch the nat gateway. | `string` | `""` | no |
| <a name="input_nat_internet_charge_type"></a> [nat\_internet\_charge\_type](#input\_nat\_internet\_charge\_type) | The internet charge type. Valid values PayByLcu and PayBySpec. | `string` | `"PayByLcu"` | no |
| <a name="input_nat_payment_type"></a> [nat\_payment\_type](#input\_nat\_payment\_type) | The billing method of the NAT gateway. | `string` | `"PayAsYouGo"` | no |
| <a name="input_nat_period"></a> [nat\_period](#input\_nat\_period) | The charge duration of the PrePaid nat gateway, in month. | `number` | `1` | no |
| <a name="input_nat_specification"></a> [nat\_specification](#input\_nat\_specification) | The specification of nat gateway. | `string` | `"Small"` | no |
| <a name="input_nat_type"></a> [nat\_type](#input\_nat\_type) | The type of NAT gateway. | `string` | `"Enhanced"` | no |
| <a name="input_one_nat_gateway_per_az"></a> [one\_nat\_gateway\_per\_az](#input\_one\_nat\_gateway\_per\_az) | Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs` | `bool` | `false` | no |
| <a name="input_pod_vswitch_names"></a> [pod\_vswitch\_names](#input\_pod\_vswitch\_names) | Explicit values to use in the Name tag on pod vswitches. If empty, Name tags are generated | `list(string)` | `[]` | no |
| <a name="input_pod_vswitch_suffix"></a> [pod\_vswitch\_suffix](#input\_pod\_vswitch\_suffix) | Suffix to append to pod vswitches name | `string` | `"pod"` | no |
| <a name="input_pod_vswitches"></a> [pod\_vswitches](#input\_pod\_vswitches) | A list of pod vswitches inside the VPC | `list(string)` | `[]` | no |
| <a name="input_private_vswitch_names"></a> [private\_vswitch\_names](#input\_private\_vswitch\_names) | Explicit values to use in the Name tag on private vswitches. If empty, Name tags are generated | `list(string)` | `[]` | no |
| <a name="input_private_vswitch_suffix"></a> [private\_vswitch\_suffix](#input\_private\_vswitch\_suffix) | Suffix to append to private vswitches name | `string` | `"private"` | no |
| <a name="input_private_vswitches"></a> [private\_vswitches](#input\_private\_vswitches) | A list of private vswitches inside the VPC | `list(string)` | `[]` | no |
| <a name="input_public_vswitch_names"></a> [public\_vswitch\_names](#input\_public\_vswitch\_names) | Explicit values to use in the Name tag on public vswitches. If empty, Name tags are generated | `list(string)` | `[]` | no |
| <a name="input_public_vswitch_suffix"></a> [public\_vswitch\_suffix](#input\_public\_vswitch\_suffix) | Suffix to append to public vswitches name | `string` | `"public"` | no |
| <a name="input_public_vswitches"></a> [public\_vswitches](#input\_public\_vswitches) | A list of public vswitches inside the VPC | `list(string)` | `[]` | no |
| <a name="input_reuse_nat_ips"></a> [reuse\_nat\_ips](#input\_reuse\_nat\_ips) | Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external\_nat\_ip\_ids' variable | `bool` | `false` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eips"></a> [eips](#output\_eips) | The names, IDs, and ip of the EIPs. |
| <a name="output_nat_gateways"></a> [nat\_gateways](#output\_nat\_gateways) | The name, IDs of the NAT gateways. |
| <a name="output_pod_vswitch_ids"></a> [pod\_vswitch\_ids](#output\_pod\_vswitch\_ids) | The IDs of the pod VSwitches. |
| <a name="output_pod_vswitches"></a> [pod\_vswitches](#output\_pod\_vswitches) | The names, IDs, and CIDR blocks of the pod VSwitches. |
| <a name="output_private_vswitch_ids"></a> [private\_vswitch\_ids](#output\_private\_vswitch\_ids) | The IDs of the private VSwitches. |
| <a name="output_private_vswitches"></a> [private\_vswitches](#output\_private\_vswitches) | The names, IDs, and CIDR blocks of the private VSwitches. |
| <a name="output_public_vswitch_ids"></a> [public\_vswitch\_ids](#output\_public\_vswitch\_ids) | The IDs of the public VSwitches. |
| <a name="output_public_vswitches"></a> [public\_vswitches](#output\_public\_vswitches) | The names, IDs, and CIDR blocks of the public VSwitches. |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The cidr block of the VPC. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC. |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | The name of the VPC. |
