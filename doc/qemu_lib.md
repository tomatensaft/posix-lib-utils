# qemu lib


## general qemu/virsh commands

list virtual machines
```
virsh list
```

list virtual storage pools
```
virsh pool-lists
```

view volume list
```
virsh vol-list default
```


handling start/stop/delete virtual machines
```
virsh start [vm]
virsh reboot [vm]
virsh shutdown [vm]
virsh destroy [vm]
virsh undefine [vm]
```

handling of snapshots
```
virsh save [vm] snapshot.state
virsh restore [vm] snapshot.state
```

enter the console
```
virsh console [vm]
```

edit configuration
```
virsh edit [vm]

```


small alpine config
```

ALPINE_VERSION=v3.19.0
wget "http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION%.*}/releases/x86_64/alpine-standard-${ALPINE_VERSION}-x86_64.iso"


wget "http://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-standard-3.19.1-x86_64.iso"

qemu-img create -f qcow2 alpine.qcow2 10G

qemu-system-x86_64 \
    -enable-kvm \
    -m 2048 \
    -smp cores=2,threads=4 \
    -nic user \
    -drive file=alpine.qcow2,media=disk \
    -cdrom alpine-standard-3.19.0-x86_64.iso

qemu-system-x86_64 \
    -m 2048 \
    -smp cores=2,threads=4 \
    -nic user \
    -drive file=alpine.qcow2,media=disk \
    -cdrom alpine-standard-3.19.1-x86_64.iso

qemu-system-x86_64 \
    -enable-kvm \
    -m 2048 \
    -nic user \
    -drive file=alpine.qcow2,media=disk




```


info todo
```

virsh dumpxml target_guest_machine > /root/target_guest_machine.xml
virsh create target_guest_machine.xml
virsh snapshot-create kvm_guest_name

qutick tutorial
sudo apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager cloud-image-utils libguestfs-tools
sudo reboot
download base image - wget https://cloud-images.ubuntu.com/releases/bionic/release/ubuntu-18.04-server-cloudimg-amd64.img
cat >user-data.txt <<EOF
#cloud-config
password: secretpassword
chpasswd: { expire: False }
ssh_pwauth: True
EOF

cloud-localds user-data.img user-data.txt

https://wiki.alpinelinux.org/wiki/Install_Alpine_in_QEMU
```
