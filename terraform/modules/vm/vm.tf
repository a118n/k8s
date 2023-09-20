resource "libvirt_cloudinit_disk" "vm_cloudinit" {
  name      = "${var.vm_name}-cloudinit.iso"
  user_data = data.template_file.user_data.rendered
  pool      = var.pool_name
}

data "template_file" "user_data" {
  template = file("templates/cloud_init.cfg")
  vars = {
    hostname = "${var.vm_name}"
  }
}

resource "libvirt_volume" "os_volume" {
  name   = "${var.vm_name}-os.qcow2"
  source = var.image_path
  pool   = var.pool_name
  format = "qcow2"
}

resource "libvirt_volume" "data_volume" {
  for_each = var.disks
  name     = "${var.vm_name}-${each.key}.qcow2"
  pool     = var.pool_name
  format   = "qcow2"
  size     = each.value.size
}

resource "libvirt_domain" "vm_domain" {
  name   = var.vm_name
  memory = var.vm_memory
  vcpu   = var.vm_vcpus
  cpu {
    mode = "host-passthrough"
  }
  video {
    type = "virtio"
  }
  qemu_agent = true
  autostart  = false

  cloudinit = libvirt_cloudinit_disk.vm_cloudinit.id

  disk {
    volume_id = libvirt_volume.os_volume.id
  }

  dynamic "disk" {
    for_each = libvirt_volume.data_volume
    content {
      volume_id = disk.value.id
    }
  }
  network_interface {
    hostname       = var.vm_name
    network_name   = var.network_name
    network_id     = var.network_id
    wait_for_lease = true
  }
}
