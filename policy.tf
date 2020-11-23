resource "vsphere_tag_category" "storage" {
  name        = "Kubernetes Storage"
  cardinality = "SINGLE"

  associable_types = [
    "Datastore",
  ]
}

resource "vsphere_tag" "vsan" {
  name        = "vsan"
  category_id = vsphere_tag_category.storage.id
}

resource "vsphere_vm_storage_policy" "vsan" {
  name        = "vsan"
  description = "vSAN storage for Kubernetes clusters"

  tag_rules {
    tag_category                 = vsphere_tag_category.storage.name
    tags                         = [ vsphere_tag.vsan.name ]
    include_datastores_with_tags = true
  }

}

resource "vsphere_tag" "usb" {
  name        = "usb"
  category_id = vsphere_tag_category.storage.id
}

resource "vsphere_vm_storage_policy" "usb" {
  name        = "usb"
  description = "USB attached storage for Kubernetes clusters"

  tag_rules {
    tag_category                 = vsphere_tag_category.storage.name
    tags                         = [ vsphere_tag.usb.name ]
    include_datastores_with_tags = true
  }

}
