#!/usr/bin/env bash
set -euo pipefail

virsh list --all | grep .k8s.internal | awk '{print $2}' | while read -r VM ; do
    virsh start "$VM"
done
