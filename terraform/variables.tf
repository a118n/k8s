variable "vm_spec" {
  type = map(object({
    cpu = number
    ram = number
    hdd = number
  }))
}

variable "vm_image_path" {
  type        = string
  description = "Absolute path to the image used for VM provisioning"
  default     = "/var/lib/libvirt/images/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
}
