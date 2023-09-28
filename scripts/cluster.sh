#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 [option...]" >&2
  echo "    start      Start the cluster"
  echo "    stop       Stop the cluster"
  echo "    restart    Reboot all cluster nodes"
  echo "    ping       Ping all cluster nodes"
}

for i in "$@"; do
  case $i in
    start)
        virsh list --all | grep .k8s.internal | awk '{print $2}' | while read -r VM ; do
            virsh start "$VM"
        done
    ;;
    stop)
        virsh list | grep .k8s.internal | awk '{print $2}' | while read -r VM ; do
            virsh shutdown "$VM" --mode acpi
        done
    ;;
    restart)
        virsh list --all | grep .k8s.internal | awk '{print $2}' | while read -r VM ; do
            virsh reboot "$VM" --mode acpi
        done
    ;;
    ping)
        virsh net-dhcp-leases k8s | awk '/^$/ {next}; {gsub("/24","",$5); print $5};' | tail -n+3 | while read -r VM ; do
            ping -c2 "$VM"
        done
    ;;
    *)
      usage
    ;;
  esac
done

if [[ $# -eq 0 ]] ; then
    usage
    exit 0
fi
