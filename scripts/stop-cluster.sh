#!/usr/bin/env bash
set -euo pipefail

virsh list | grep .k8s.internal | awk '{print $2}' | while read -r VM ; do
    virsh shutdown "$VM" --mode acpi
done
