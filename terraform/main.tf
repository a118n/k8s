# POOL
resource "libvirt_pool" "k8s" {
  name = "k8s"
  type = "dir"
  path = "/var/lib/libvirt/pools/k8s"
}

# K8S Cluster
module "k8s_node" {
  source = "./modules/vm"

  for_each = var.k8s_cluster

  vm_name      = "${each.key}.k8s.internal"
  pool_name    = libvirt_pool.k8s.name
  vm_memory    = each.value.ram
  vm_vcpus     = each.value.cpu
  image_path   = each.value.image_path
  network_name = "default"
  network_id   = null

  depends_on = [libvirt_pool.k8s]
}

output "k8s_node_info" {
  # Splat expression only works with lists, sets, and tuples, but module_test_srv is a map
  value = values(module.k8s_node)[*].vm_info
}
