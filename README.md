# Deploy local k8s cluster on KVM (libvirt) using Terraform and Ansible

## Prepare the host
Some preliminary steps are required on the host (Fedora):

### Disable SELinux
```
sudo grubby --update-kernel ALL --args selinux=0
```

### Install libvirt
```
sudo dnf install -y @virtualization
sudo usermod -aG libvirt $USER
# This is a temporary workaround due to a bug in systemd 253.5
echo 'VIRTNETWORKD_ARGS=' | sudo tee /etc/sysconfig/virtnetworkd
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
```
curl -LO https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2
sudo mv Rocky-9-GenericCloud-Base.latest.x86_64.qcow2 /var/lib/libvirt/images/
qemu-img resize /var/lib/libvirt/images/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2 30G
```

## Terraform
Now we can deploy our infrastructure using Terraform:
```
cd terraform
terraform init
terraform apply -auto-approve
```

## Ansible
Now let's provision our k8s cluster:
```
cd ansible
ansible-playbook k8s_provision.yml
```
