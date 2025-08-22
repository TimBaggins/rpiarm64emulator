#!/bin/bash

# This script launches a pre-configured RaspiOS QEMU image.

set -e

# --- Configuration ---
KERNEL_VERSION="6.1.34"
IMAGE_FILENAME="2020-08-20-raspios-buster-arm64-lite.img"
KERNEL_DIR="linux-${KERNEL_VERSION}"

# --- Run QEMU ---
echo "--- Starting QEMU with persistent image ---"

# Check if the kernel image exists
if [ ! -f ~/"${KERNEL_DIR}_Image" ]; then
    echo "Error: Kernel image not found. Please run the setup script first."
    exit 1
fi

# Check if the RaspiOS image exists
if [ ! -f "${IMAGE_FILENAME}" ]; then
    echo "Error: RaspiOS image not found. Please run the setup script first."
    exit 1
fi

qemu-system-aarch64 \
-machine virt -cpu cortex-a72 -smp 6 -m 4G \
-kernel ~/"${KERNEL_DIR}_Image" -append "root=/dev/vda2 rootfstype=ext4 rw panic=0 console=ttyAMA0" \
-drive format=raw,file="${IMAGE_FILENAME}",if=none,id=hd0,cache=writeback \
-device virtio-blk,drive=hd0,bootindex=0 \
-netdev user,id=mynet,hostfwd=tcp::2222-:22 \
-device virtio-net-pci,netdev=mynet \
-monitor telnet:127.0.0.1:5555,server,nowait -nographic
