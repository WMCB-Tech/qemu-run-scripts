#!/bin/bash
### A Script to Start Alpine Linux
### Will use Virtio Drivers as well as QXL
### Drivers to lessen the overhead
stty intr ^N
qemu-system-x86_64 \
 -cpu max -smp cpus=4,cores=4,threads=1,sockets=1 \
 -accel kvm -m 1024 \
 -drive file=alpine.qcow2,if=virtio,cache=writeback \
 -boot menu=on \
 -device virtio-balloon \
 -object rng-random,filename=/dev/urandom,id=rng0 \
 -device virtio-rng-pci,rng=rng0,id=virtio-rng-pci0 \
 -fsdev local,security_model=none,id=fsdev0,path=/ \
 -device virtio-9p-pci,fsdev=fsdev0,mount_tag=hostfs \
 -netdev user,id=eth0 \
 -device virtio-net-pci,netdev=eth0,id=virtio-net-pci0 \
 -net nic -net user,smb=/ \
 -device virtio-tablet-pci \
 -global qxl-vga.ram_size_mb=128 -vga qxl \
 -nographic -parallel none \
 -spice port=5900,disable-ticketing \
 -monitor tcp::4444,server,telnet,nowait "$@" \
