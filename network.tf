data "vsphere_distributed_virtual_switch" "homelab" {
  name          = "homelab"
  datacenter_id = data.vsphere_datacenter.garage.id
}

data "vsphere_host" "bourbon" {
  name = "bourbon.${local.subdomain}"
  datacenter_id = data.vsphere_datacenter.garage.id
}

data "vsphere_host" "rye" {
  name = "rye.${local.subdomain}"
  datacenter_id = data.vsphere_datacenter.garage.id
}

locals {
  host_ids = [ data.vsphere_host.bourbon.id, data.vsphere_host.rye.id ]
}

resource "vsphere_distributed_port_group" "workload" {
  name                            = "workload-pg"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.homelab.id

  vlan_id = 103
}

resource "vsphere_vnic" "workload" {
  count = length(local.host_ids)

  host                    = local.host_ids[count.index]
  distributed_switch_port = data.vsphere_distributed_virtual_switch.homelab.id
  distributed_port_group  = vsphere_distributed_port_group.workload.id

  ipv4 {
    ip = cidrhost("10.16.0.0/24", 200+((count.index+1)*10))
    netmask = "255.255.255.0"
  }

  ipv6 {
    addresses  = []
    autoconfig = false
    dhcp       = false
  }

  netstack = "defaultTcpipStack"
}

resource "vsphere_distributed_port_group" "load_balancer" {
  name                            = "load-balancer-pg"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.homelab.id

  vlan_id = 104
}

resource "vsphere_vnic" "load_balancer" {
  count = length(local.host_ids)

  host                    = local.host_ids[count.index]
  distributed_switch_port = data.vsphere_distributed_virtual_switch.homelab.id
  distributed_port_group  = vsphere_distributed_port_group.load_balancer.id

  ipv4 {
    ip = cidrhost("10.24.0.0/24", 200+((count.index+1)*10))
    netmask = "255.255.255.0"
  }

  ipv6 {
    addresses  = []
    autoconfig = false
    dhcp       = false
  }

  netstack = "defaultTcpipStack"
}
