variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# VPC
################################################################################

variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "cidr" {
  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

################################################################################
# Publiс Vswitches
################################################################################

variable "public_vswitches" {
  description = "A list of public vswitches inside the VPC"
  type        = list(string)
  default     = []
}

variable "public_vswitch_names" {
  description = "Explicit values to use in the Name tag on public vswitches. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "public_vswitch_suffix" {
  description = "Suffix to append to public vswitches name"
  type        = string
  default     = "public"
}

################################################################################
# Private Vswitches
################################################################################

variable "private_vswitches" {
  description = "A list of private vswitches inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_vswitch_names" {
  description = "Explicit values to use in the Name tag on private vswitches. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "private_vswitch_suffix" {
  description = "Suffix to append to private vswitches name"
  type        = string
  default     = "private"
}

variable "create_private_nat_gateway_route" {
  description = "Controls if a nat gateway route should be created to give internet access to the private vswitches"
  type        = bool
  default     = true
}

################################################################################
# Pod Vswitches
################################################################################

variable "pod_vswitches" {
  description = "A list of pod vswitches inside the VPC"
  type        = list(string)
  default     = []
}

variable "pod_vswitch_names" {
  description = "Explicit values to use in the Name tag on pod vswitches. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "pod_vswitch_suffix" {
  description = "Suffix to append to pod vswitches name"
  type        = string
  default     = "pod"
}

variable "create_pod_nat_gateway_route" {
  description = "Controls if a nat gateway route should be created to give internet access to the pod vswitches"
  type        = bool
  default     = true
}

################################################################################
# NAT Gateway
################################################################################

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`"
  type        = bool
  default     = false
}

variable "reuse_nat_ips" {
  description = "Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable"
  type        = bool
  default     = false
}

variable "external_nat_ip_ids" {
  description = "List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips)"
  type        = list(string)
  default     = []
}

variable "external_nat_ips" {
  description = "List of EIP IPs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips)"
  type        = list(string)
  default     = []
}

variable "nat_gateway_name" {
  description = "The name prefix used to launch the nat gateway."
  type        = string
  default     = ""
}

variable "nat_specification" {
  description = "The specification of nat gateway."
  type        = string
  default     = "Small"
}

variable "nat_payment_type" {
  description = "The billing method of the NAT gateway."
  type        = string
  default     = "PayAsYouGo"
}

variable "nat_period" {
  description = "The charge duration of the PrePaid nat gateway, in month."
  type        = number
  default     = 1
}

variable "nat_internet_charge_type" {
  description = "The internet charge type. Valid values PayByLcu and PayBySpec."
  type        = string
  default     = "PayByLcu"
}

variable "nat_type" {
  description = "The type of NAT gateway."
  type        = string
  default     = "Enhanced"
}

// eip variables
variable "eip_name" {
  description = "The name prefix used to launch the eip. "
  type        = string
  default     = ""
}

variable "eip_bandwidth" {
  description = "The eip bandwidth."
  type        = number
  default     = 200
}

variable "eip_payment_type" {
  description = "The billing method of the NAT gateway."
  type        = string
  default     = "PayAsYouGo"
}

variable "eip_internet_charge_type" {
  description = "Internet charge type of the EIP, Valid values are `PayByBandwidth`, `PayByTraffic`. "
  type        = string
  default     = "PayByTraffic"
}

variable "eip_period" {
  description = "The duration that you will buy the EIP, in month."
  type        = number
  default     = 1
}

variable "eip_tags" {
  description = "The tags used to launch the eip."
  type        = map(string)
  default     = {}
}
