output "vpc_id" {
  description = "The ID of the VPC."
  value       = alicloud_vpc.this[0].id
}

output "vpc_name" {
  description = "The name of the VPC."
  value       = var.name
}

output "vpc_cidr_block" {
  description = "The cidr block of the VPC."
  value       = var.cidr
}

output "public_vswitch_ids" {
  description = "The IDs of the public VSwitches."
  value       = alicloud_vswitch.public.*.id
}

output "public_vswitches" {
  description = "The names, IDs, and CIDR blocks of the public VSwitches."
  value = [
    for idx, vswitch_id in alicloud_vswitch.public.*.id :
    format(
      "%s  %s  %s",
      alicloud_vswitch.public[idx].name,
      vswitch_id,
      alicloud_vswitch.public[idx].cidr_block
    )
  ]
}

output "private_vswitch_ids" {
  description = "The IDs of the private VSwitches."
  value       = alicloud_vswitch.private.*.id
}

output "private_vswitches" {
  description = "The names, IDs, and CIDR blocks of the private VSwitches."
  value = [
    for idx, vswitch_id in alicloud_vswitch.private.*.id :
    format(
      "%s  %s  %s",
      alicloud_vswitch.private[idx].name,
      vswitch_id,
      alicloud_vswitch.private[idx].cidr_block
    )
  ]
}

output "pod_vswitch_ids" {
  description = "The IDs of the pod VSwitches."
  value       = alicloud_vswitch.pod.*.id
}

output "pod_vswitches" {
  description = "The names, IDs, and CIDR blocks of the pod VSwitches."
  value = [
    for idx, vswitch_id in alicloud_vswitch.pod.*.id :
    format(
      "%s  %s  %s",
      alicloud_vswitch.pod[idx].name,
      vswitch_id,
      alicloud_vswitch.pod[idx].cidr_block
    )
  ]
}

output "nat_gateways" {
  description = "The name, IDs of the NAT gateways."
  value = [
    for idx, nat_gatway_id in alicloud_nat_gateway.this.*.id :
    format(
      "%s  %s",
      alicloud_nat_gateway.this[idx].name,
      nat_gatway_id
    )
  ]
}

output "eips" {
  description = "The names, IDs, and ip of the EIPs."
  value = [
    for idx, alicloud_eip_id in alicloud_eip.this.*.id :
    format(
      "%s  %s  %s",
      alicloud_eip.this[idx].name,
      alicloud_eip_id,
      alicloud_eip.this[idx].ip_address
    )
  ]
}
