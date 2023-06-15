# Deploy local k8s cluster on KVM (libvirt) using Terraform and Ansible

## Prepare the host
Some preliminary steps are required on the host (Fedora):

### Install & configure libvirt
```
sudo dnf install -y @virtualization
echo 'mode = "legacy"' | sudo tee -a /etc/libvirt/libvirt.conf
sudo usermod -aG libvirt $USER
sudo systemctl enable --now libvirtd
```

### Install libvirt hooks
In order to correctly resolve DNS names of VMs while using systemd-resolved we need to install libvirt hooks to utilize split DNS:

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
Let's install Ansible first:
```
sudo dnf install -y python3-pip
pip install --user ansible ansible-lint
```

Now let's provision our k8s cluster:
```
cd ansible
ansible-playbook k8s_provision.yml
```
