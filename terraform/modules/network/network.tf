resource "libvirt_network" "network" {
  name      = var.network_name
  mode      = var.network_mode
  bridge    = var.network_bridge
  domain    = var.network_domain
  addresses = [var.network_cidr]
  autostart = true

  dns {
    enabled    = true
    local_only = true
  }

  dhcp {
    enabled = true
  }
}
