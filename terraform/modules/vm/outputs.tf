output "vm_info" {
  value = {
    name = libvirt_domain.vm_domain.name,
    ip   = libvirt_domain.vm_domain.network_interface.0.addresses.0
  }
  description = "VM's info containing it's name and an IP address"
}
