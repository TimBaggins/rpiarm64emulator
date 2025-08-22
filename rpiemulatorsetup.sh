#!/bin/bash

set -e

# --- Configuration ---
KERNEL_VERSION="6.1.34"
RASPI_IMAGE_URL="https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2020-08-24/2020-08-20-raspios-buster-arm64-lite.zip"
IMAGE_FILENAME="2020-08-20-raspios-buster-arm64-lite.img"
KERNEL_TARBALL="linux-${KERNEL_VERSION}.tar.xz"
KERNEL_DIR="linux-${KERNEL_VERSION}"
MOUNT_POINT="~/mnt/rpi"

# --- User Input ---
read -p "Enter a username for the new user: " USERNAME
read -s -p "Enter a password for the new user: " PASSWORD
echo # Add a newline after password entry

# --- Installation and Setup ---

## Install Required Packages
echo "--- Installing required packages ---"
sudo apt-get update
sudo apt-get install -y qemu-system qemu qemubuilder qemu-system-gui qemu-system-arm qemu-utils qemu-system-data unzip
sudo apt install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu flex bison libssl-dev

## Pull and Extract RaspiOS Image
echo "--- Pulling and extracting RaspiOS image ---"
wget -O "${IMAGE_FILENAME}.zip" "${RASPI_IMAGE_URL}"
unzip "${IMAGE_FILENAME}.zip"

## Build Kernel
echo "--- Building kernel ---"
wget "https://cdn.kernel.org/pub/linux/kernel/v6.x/${KERNEL_TARBALL}"
tar xvJf "${KERNEL_TARBALL}"
cd "${KERNEL_DIR}"

ARCH=arm64 CROSS_COMPILE=/usr/bin/aarch64-linux-gnu- make defconfig
ARCH=arm64 CROSS_COMPILE=/usr/bin/aarch64-linux-gnu- make kvm_guest.config
ARCH=arm64 CROSS_COMPILE=/usr/bin/aarch64-linux-gnu- make -j8

cp arch/arm64/boot/Image ~/"${KERNEL_DIR}_Image"
cd ~

## Mount Image and Configure SSH
echo "--- Mounting image and configuring SSH ---"
sudo mkdir -p "${MOUNT_POINT}"
sudo mount -o loop,offset=4194304 "${IMAGE_FILENAME}" "${MOUNT_POINT}"

# Hash password and create user
HASHED_PASSWORD=$(echo "${PASSWORD}" | openssl passwd -6 -stdin)
echo "${USERNAME}:${HASHED_PASSWORD}" | sudo tee "${MOUNT_POINT}/userconf.txt" > /dev/null

sudo touch "${MOUNT_POINT}/ssh"

# Unmount the image
echo "--- Unmounting image ---"
sudo umount "${MOUNT_POINT}"

# --- Run QEMU ---
echo "--- Starting QEMU ---"
qemu-system-aarch64 \
-machine virt -cpu cortex-a72 -smp 6 -m 4G \
-kernel "${KERNEL_DIR}_Image" -append "root=/dev/vda2 rootfstype=ext4 rw panic=0 console=ttyAMA0" \
-drive format=raw,file="${IMAGE_FILENAME}",if=none,id=hd0,cache=writeback \
-device virtio-blk,drive=hd0,bootindex=0 \
-netdev user,id=mynet,hostfwd=tcp::2222-:22 \
-device virtio-net-pci,netdev=mynet \
-monitor telnet:127.0.0.1:5555,server,nowait -nographic
