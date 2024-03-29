# Deploy local K8S cluster on KVM (libvirt) using Terraform and Ansible

## Prepare the host
Some preliminary steps are required on the host. Fedora, in this example.

### Disable SELinux
```
sudo grubby --update-kernel ALL --args selinux=0
```

### Install libvirt
```
sudo dnf install -y @virtualization
sudo usermod -aG libvirt $USER
echo "export LIBVIRT_DEFAULT_URI='qemu:///system'" >> ~/.bashrc && source ~/.bashrc
sudo systemctl enable --now libvirtd
```

### Install libvirt hook
In order to correctly resolve DNS names of VMs while using systemd-resolved we need to install libvirt hook:
```
sudo dnf install -y make publicsuffix-list
sudo mkdir -p /etc/libvirt/hooks/network.d
git clone https://github.com/tprasadtp/libvirt-systemd-resolved.git
cd libvirt-systemd-resolved
sudo make install
sudo systemctl restart libvirtd.service
```

### Download OS image
Choose between Debian 12:
```
sudo curl -L -o /var/lib/libvirt/images/debian-12-generic-amd64.qcow2 https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2
sudo qemu-img resize /var/lib/libvirt/images/debian-12-generic-amd64.qcow2 30G
```

Or Rocky Linux 9:
```
sudo curl -L -o /var/lib/libvirt/images/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2 https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2
sudo qemu-img resize /var/lib/libvirt/images/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2 30G
```

## Terraform
Change variable `vm_image_path` in `terraform/variables.tf` to image path from previous step.
For example:
```
variable "vm_image_path" {
  type        = string
  description = "Absolute path to the image used for VM provisioning"
  default     = "/var/lib/libvirt/images/debian-12-generic-amd64.qcow2"
}
```

Now we can deploy our infrastructure using Terraform:
```
cd terraform
terraform init
terraform apply -auto-approve
```

## Ansible
### Install required libraries
To generate CA certificate we'll need cryptography Python package:
```
sudo dnf install python3-cryptography
```

### Provision cluster:
```
cd ../ansible
ansible-playbook k8s_provision.yml --ask-become-pass
```

## Local DNS
In order to properly utilize Ingress, add cluster records to /etc/hosts:
```
echo "$(virsh net-dhcp-leases k8s | grep cluster | awk '{gsub("/24","",$5); print $5}') cluster.k8s.internal" | sudo tee -a /etc/hosts
echo "$(virsh net-dhcp-leases k8s | grep cluster | awk '{gsub("/24","",$5); print $5}') argocd.k8s.internal" | sudo tee -a /etc/hosts
echo "$(virsh net-dhcp-leases k8s | grep cluster | awk '{gsub("/24","",$5); print $5}') hubble.k8s.internal" | sudo tee -a /etc/hosts
echo "$(virsh net-dhcp-leases k8s | grep cluster | awk '{gsub("/24","",$5); print $5}') grafana.k8s.internal" | sudo tee -a /etc/hosts
echo "$(virsh net-dhcp-leases k8s | grep cluster | awk '{gsub("/24","",$5); print $5}') vmagent.k8s.internal" | sudo tee -a /etc/hosts
echo "$(virsh net-dhcp-leases k8s | grep cluster | awk '{gsub("/24","",$5); print $5}') longhorn.k8s.internal" | sudo tee -a /etc/hosts
```

Now we should be able to access the cluster:
```
kubectl cluster-info
```

ArgoCD:
https://argocd.k8s.internal

Hubble UI:
https://hubble.k8s.internal

Grafana:
https://grafana.k8s.internal

VMAgent:
https://vmagent.k8s.internal/targets

Longhorn:
https://longhorn.k8s.internal

Of course, when we deploy anything else via Ingress, we'll have to add these records as well.

## ArgoCD
Let's get default admin password first:
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Afterwards we can login with username `admin` and password from the previous step.


## Grafana
As with ArgoCD, we can get default admin password like this:
```
kubectl -n monitoring get secret victoria-metrics-k8s-stack-grafana -o jsonpath="{.data.admin-password}" | base64 -d
```

Afterwards we can login with username `admin` and password from the previous step.
