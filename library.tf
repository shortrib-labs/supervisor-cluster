resource "vsphere_content_library" "tkg" {
  name            = "tanzu-kubernetes-grid"
  storage_backing = [ data.vsphere_datastore.vsan.id ]
  description     = "Tanzu Kubernetes dependencies provided by VMware"

  subscription {
    subscription_url = "https://wp-content.vmware.com/v2/latest/lib.json"
    automatic_sync   = true 
    on_demand        = false
  }
}

resource "vsphere_content_library" "haproxy" {
  name            = "haproxy"
  storage_backing = [ data.vsphere_datastore.vsan.id ]
  description     = "HAProxy load balancer for Kubernetes load balancing"
}

resource "vsphere_content_library_item" "haproxy" {
  name        = "vmware-haproxy-v0.1.8.ova"
  library_id  = vsphere_content_library.haproxy.id
  file_url    = "https://cdn.haproxy.com/download/haproxy/vsphere/ova/vmware-haproxy-v0.1.8.ova"
}
