variable "pool_name" {
  description = "Name of the pool where to create VM volumes"
  type        = string
}

variable "vm_name" {
  description = "Name of VM"
  type        = string
}

variable "vm_memory" {
  description = "Amount of memory for VM"
  type        = number
}

variable "vm_vcpus" {
  description = "Amount of VCPUs for VM"
  type        = number
}

variable "image_path" {
  description = "Local path to the OS image in qcow2 format"
  type        = string
}

variable "network_id" {
  type        = string
  description = "Terraform-managed network ID for VM"
}

variable "network_name" {
  type        = string
  description = "Existing network name for VM"
}
