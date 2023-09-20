variable "vm_spec" {
  type = map(object({
    cpu = number
    ram = number
    disks = map(object({
      size = number
    }))
  }))
}

variable "vm_image_path" {
  type        = string
  description = "Absolute path to the image used for VM provisioning"
  default     = "/var/lib/libvirt/images/debian-12-generic-amd64.qcow2"
}
