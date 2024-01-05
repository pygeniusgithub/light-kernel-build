#!/bin/bash

# Check if kernel source directory exists
KERNEL_SOURCE_DIR="linux-$(uname -r)"
if [ ! -d "$KERNEL_SOURCE_DIR" ]; then
  echo "Kernel source directory $KERNEL_SOURCE_DIR not found. Please download and extract the kernel source first."
  exit 1
fi

# Navigate to the kernel source directory
cd $KERNEL_SOURCE_DIR

# Generate configuration based on the currently running kernel
make localmodconfig

# Build the kernel
make -j$(nproc)

# Install modules
sudo make modules_install

# Install the kernel image and update GRUB
sudo make install

# Navigate back to the parent directory
cd ..

# Download and extract BusyBox
BUSYBOX_VERSION="1.33.1"
wget https://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2
tar -xf busybox-${BUSYBOX_VERSION}.tar.bz2
cd busybox-${BUSYBOX_VERSION}

# Configure BusyBox
make defconfig

# Build BusyBox
make -j$(nproc)

# Install BusyBox
make install

# Create initramfs directory
INITRAMFS_DIR="initramfs"
mkdir -p ${INITRAMFS_DIR}/bin
mkdir -p ${INITRAMFS_DIR}/dev
mkdir -p ${INITRAMFS_DIR}/etc
mkdir -p ${INITRAMFS_DIR}/proc
mkdir -p ${INITRAMFS_DIR}/sys
mkdir -p ${INITRAMFS_DIR}/tmp

# Copy BusyBox files to initramfs
cp -R _install/* ${INITRAMFS_DIR}/

# Create init script for BusyBox
echo -e '#!/bin/sh\n\nmount -t proc none /proc\nmount -t sysfs none /sys\nexec /bin/sh' > ${INITRAMFS_DIR}/init
chmod +x ${INITRAMFS_DIR}/init

# Create symlink for sh
ln -s /bin/busybox ${INITRAMFS_DIR}/bin/sh

# Create initramfs
find ${INITRAMFS_DIR} -print0 | cpio --null -ov --format=newc > initramfs.cpio
gzip initramfs.cpio

# Copy the initramfs image to the boot directory
cp initramfs.cpio.gz /boot/

# Navigate back to the parent directory
cd ..

# Download and extract Bash
BASH_VERSION="5.1"
wget https://ftp.gnu.org/gnu/bash/bash-${BASH_VERSION}.tar.gz
tar -xf bash-${BASH_VERSION}.tar.gz
cd bash-${BASH_VERSION}

# Configure Bash
./configure

# Build and install Bash
make -j$(nproc)
sudo make install

echo "Kernel, BusyBox, initramfs, and Bash installation completed successfully!"
