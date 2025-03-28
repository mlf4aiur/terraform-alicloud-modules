################################################################################
# VPC
################################################################################

resource "alicloud_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  vpc_name   = var.name
  cidr_block = var.cidr

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )
}
locals {
  create_public_vswitches = var.create_vpc && length(var.public_vswitches) > 0
}

################################################################################
# Publiс Vswitchs
################################################################################

resource "alicloud_vswitch" "public" {
  count = local.create_public_vswitches && (length(var.public_vswitches) >= length(var.availability_zones)) ? length(var.public_vswitches) : 0

  cidr_block = element(concat(var.public_vswitches, [""]), count.index)
  vpc_id     = alicloud_vpc.this[0].id
  zone_id    = length(regexall("^[a-z]{2}-", element(var.availability_zones, count.index))) > 0 ? element(var.availability_zones, count.index) : null

  vswitch_name = try(
    var.public_vswitch_names[count.index],
    format("${var.name}-${var.public_vswitch_suffix}-%s", element(var.availability_zones, count.index))
  )

  tags = merge(
    {
      Name = try(
        var.public_vswitch_names[count.index],
        format("${var.name}-${var.public_vswitch_suffix}-%s", element(var.availability_zones, count.index))
      )
    },
    var.tags,
  )
}

################################################################################
# Private Vswitchs
################################################################################

locals {
  create_private_vswitches = var.create_vpc && length(var.private_vswitches) > 0
}

resource "alicloud_vswitch" "private" {
  count = local.create_private_vswitches && (length(var.private_vswitches) >= length(var.availability_zones)) ? length(var.private_vswitches) : 0

  cidr_block = element(concat(var.private_vswitches, [""]), count.index)
  vpc_id     = alicloud_vpc.this[0].id
  zone_id    = length(regexall("^[a-z]{2}-", element(var.availability_zones, count.index))) > 0 ? element(var.availability_zones, count.index) : null

  vswitch_name = try(
    var.private_vswitch_names[count.index],
    format("${var.name}-${var.private_vswitch_suffix}-%s", element(var.availability_zones, count.index))
  )

  tags = merge(
    {
      Name = try(
        var.private_vswitch_names[count.index],
        format("${var.name}-${var.private_vswitch_suffix}-%s", element(var.availability_zones, count.index))
      )
    },
    var.tags,
  )
}

################################################################################
# Pod Vswitchs
################################################################################

locals {
  create_pod_vswitches = var.create_vpc && length(var.pod_vswitches) > 0
}

resource "alicloud_vswitch" "pod" {
  count = local.create_pod_vswitches && (length(var.pod_vswitches) >= length(var.availability_zones)) ? length(var.pod_vswitches) : 0

  cidr_block = element(concat(var.pod_vswitches, [""]), count.index)
  vpc_id     = alicloud_vpc.this[0].id
  zone_id    = length(regexall("^[a-z]{2}-", element(var.availability_zones, count.index))) > 0 ? element(var.availability_zones, count.index) : null

  vswitch_name = try(
    var.pod_vswitch_names[count.index],
    format("${var.name}-${var.pod_vswitch_suffix}-%s", element(var.availability_zones, count.index))
  )

  tags = merge(
    {
      Name = try(
        var.pod_vswitch_names[count.index],
        format("${var.name}-${var.pod_vswitch_suffix}-%s", element(var.availability_zones, count.index))
      )
    },
    var.tags,
  )
}

################################################################################
# NAT Gateway
################################################################################

locals {
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.availability_zones) : local.max_vswitch_length
  nat_gateway_ips   = var.reuse_nat_ips ? var.external_nat_ips : alicloud_eip.this[*].ip_address
  nat_gateway_ids   = var.reuse_nat_ips ? var.external_nat_ip_ids : alicloud_eip.this[*].id
}

resource "alicloud_eip" "this" {
  count = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  address_name = format(
    "${var.name}-%s",
    element(var.availability_zones, var.single_nat_gateway ? 0 : count.index),
  )

  bandwidth            = var.eip_bandwidth
  payment_type         = var.eip_payment_type
  internet_charge_type = var.eip_internet_charge_type
  period               = var.eip_period

  tags = merge(
    {
      Name = format(
        "${var.name}-%s",
        element(var.availability_zones, var.single_nat_gateway ? 0 : count.index),
      )
    },
    var.tags,
  )
}

resource "alicloud_nat_gateway" "this" {
  count = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  vpc_id = alicloud_vpc.this[0].id

  nat_gateway_name = format(
    "${var.name}-%s",
    element(var.availability_zones, var.single_nat_gateway ? 0 : count.index),
  )

  vswitch_id = element(
    alicloud_vswitch.public[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )

  specification        = var.nat_specification
  payment_type         = var.nat_payment_type
  period               = var.nat_period
  internet_charge_type = var.nat_internet_charge_type
  nat_type             = var.nat_type

  tags = merge(
    {
      Name = format(
        "${var.name}-%s",
        element(var.availability_zones, var.single_nat_gateway ? 0 : count.index),
      )
    },
    var.tags,
  )
}

resource "alicloud_eip_association" "this" {
  count = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  allocation_id = element(
    local.nat_gateway_ids,
    var.single_nat_gateway ? 0 : count.index,
  )

  instance_id = element(
    alicloud_nat_gateway.this[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

resource "alicloud_snat_entry" "private" {
  count = local.create_private_vswitches && (length(var.private_vswitches) >= length(var.availability_zones)) ? length(var.private_vswitches) : 0

  snat_entry_name = try(
    var.private_vswitch_names[count.index],
    format("${var.name}-${var.private_vswitch_suffix}-%s", element(var.availability_zones, count.index))
  )

  snat_table_id = element(
    alicloud_nat_gateway.this[*].snat_table_ids,
    var.single_nat_gateway ? 0 : count.index,
  )

  source_vswitch_id = alicloud_vswitch.private[count.index].id

  snat_ip = element(
    local.nat_gateway_ips,
    var.single_nat_gateway ? 0 : count.index,
  )

  depends_on = [alicloud_eip_association.this]
}

resource "alicloud_snat_entry" "pod" {
  count = local.create_pod_vswitches && (length(var.pod_vswitches) >= length(var.availability_zones)) ? length(var.pod_vswitches) : 0

  snat_entry_name = try(
    var.pod_vswitch_names[count.index],
    format("${var.name}-${var.pod_vswitch_suffix}-%s", element(var.availability_zones, count.index))
  )

  snat_table_id = element(
    alicloud_nat_gateway.this[*].snat_table_ids,
    var.single_nat_gateway ? 0 : count.index,
  )

  source_vswitch_id = alicloud_vswitch.pod[count.index].id

  snat_ip = element(
    local.nat_gateway_ips,
    var.single_nat_gateway ? 0 : count.index,
  )

  depends_on = [alicloud_eip_association.this]
}
