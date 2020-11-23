provider "vsphere" {
  user = "administrator@${var.domain}"
  password  = var.vcenter_password
  vsphere_server = "vcenter.${local.subdomain}"
}
