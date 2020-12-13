# qemu-run-scripts
Setting up VirtIO Devices is pain in the butt

Using all possible virtio devices for enhanced performance

Do not copy-paste this unless you know what you're doing and the guest OS supports this

Without KVM (For Termux/Without QXL)
```

#!/bin/bash
### Use CTRL+] Interrupt as to allow terminating
### Programs than qemu
stty intr ^]

### QEMU Launch Parameters
qemu-system-x86_64 \
 -cpu max -smp cpus=4,cores=4,threads=1,sockets=1 \
 -accel tcg,tb-size=512 -m 1024,slots=4,maxmem=4G \
 -boot menu=on \
 -drive file=alpine.qcow2,if=none,id=virtio-disk0 \
 -device virtio-blk-pci,scsi=off,drive=virtio-disk0,bootindex=2 \
 -drive file=alpine.iso,if=none,media=cdrom,id=cd0 \
 -device virtio-scsi-pci,id=virtio-scsi-pci0 \
 -device scsi-cd,bus=virtio-scsi-pci0.0,id=scsi-cd0,drive=cd0 \
 -device virtio-balloon \
 -object rng-random,filename=/dev/urandom,id=rng0 \
 -device virtio-rng-pci,rng=rng0,id=virtio-rng-pci0 \
 -fsdev local,security_model=passthrough,id=fsdev0,path=/sdcard \
 -device virtio-9p-pci,fsdev=fsdev0,mount_tag=hostfs \
 -netdev user,id=eth0 \
 -device virtio-net-pci,netdev=eth0,id=virtio-net0 \
 -object cryptodev-backend-builtin,id=cryptodev0 \
 -device virtio-crypto-pci,id=crypto0,cryptodev=cryptodev0 \
 -object memory-backend-file,id=mem1,share,mem-path=virtmem.img,size=1G,share \
 -device virtio-pmem-pci,memdev=mem1,id=nv1 \
 -device virtio-serial-pci,id=virtio-serial0 \
 -chardev tty,id=charconsole0,mux=on,path=$(tty) \
 -device virtconsole,chardev=charconsole0,id=console0 \
 -device virtio-gpu-pci \
 -device virtio-tablet-pci \
 -device virtio-mouse-pci \
 -device virtio-keyboard-pci \
 -nographic -parallel none \
 -vnc none -monitor tcp::4444,server,telnet,nowait "$@"
```
