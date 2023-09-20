vm_spec = {
  "cluster" = {
    cpu   = 1
    ram   = 1024
    disks = {}
  },
  "node-01" = {
    cpu   = 2
    ram   = 2048
    disks = {}
  },
  "node-02" = {
    cpu   = 2
    ram   = 2048
    disks = {}
  },
  "node-03" = {
    cpu   = 2
    ram   = 2048
    disks = {}
  },
  "node-04" = {
    cpu = 2
    ram = 2048
    disks = {
      "data-01" = { size = 21474836480 }
    }
  },
  "node-05" = {
    cpu = 2
    ram = 2048
    disks = {
      "data-01" = { size = 21474836480 }
    }
  },
  "node-06" = {
    cpu = 2
    ram = 2048
    disks = {
      "data-01" = { size = 21474836480 }
    }
  }
}
