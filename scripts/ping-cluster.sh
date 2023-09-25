#!/usr/bin/env bash
set -euo pipefail

virsh net-dhcp-leases k8s | awk '/^$/ {next}; {gsub("/24","",$5); print $5};' | tail -n+3 | while read -r VM ; do
    ping -c2 "$VM"
done
