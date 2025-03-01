#!/bin/bash
# SnackLinux CF Card Image Creator
# Creates a bootable image file for i486 systems

set -e  # Exit on any error

# Configuration
NOW=$(date +'%d.%m.%y')
IMAGE_NAME="snacklinux_cf_i486_${NOW}.img"
# Size in MB
IMAGE_SIZE=450  
ROOTFS_PATH="/opt/snacklinux_rootfs"
KERNEL_PATH="linux/arch/x86/boot/bzImage"
MOUNT_POINT="/mnt/snacklinux"
LOOP_DEVICE=""

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Clean up on exit or error
cleanup() {
  echo "Cleaning up..."
  if mountpoint -q "$MOUNT_POINT"; then
    umount "$MOUNT_POINT"
  fi
  
  if [ -n "$LOOP_DEVICE" ]; then
    losetup -d "$LOOP_DEVICE"
  fi
  
  echo "Done."
}

trap cleanup EXIT

echo "Creating empty disk image ($IMAGE_SIZE MB)..."
dd if=/dev/zero of="$IMAGE_NAME" bs=1M count="$IMAGE_SIZE" status=progress

# Set up loop device
echo "Setting up loop device..."
LOOP_DEVICE=$(losetup -f)
losetup -P "$LOOP_DEVICE" "$IMAGE_NAME"

# Create partition
echo "Creating partition..."
fdisk "$LOOP_DEVICE" <<EOF
o
n
p
1


w
EOF

echo "Creating ext2 filesystem..."
mkfs.ext2 "${LOOP_DEVICE}p1"

echo "Mounting filesystem..."
mkdir -p "$MOUNT_POINT"
mount "${LOOP_DEVICE}p1" "$MOUNT_POINT"

echo "Copying root filesystem..."
cp -a "$ROOTFS_PATH"/* "$MOUNT_POINT"/

echo "Setting up boot directory..."
mkdir -p "$MOUNT_POINT/boot/extlinux"

# Copy kernel if not in rootfs
if [ ! -f "$MOUNT_POINT/boot/extlinux/bzImage" ]; then
  echo "Copying kernel image..."
  cp "$KERNEL_PATH" "$MOUNT_POINT/boot/extlinux/"
fi

echo "Copying extlinux configuration..."
cp configs/extlinux/extlinux.conf "$MOUNT_POINT/boot/extlinux/extlinux.conf"
# Install extlinux
# Note: Use extlinux 4.07
echo "Installing extlinux..."
extlinux --install "$MOUNT_POINT/boot/extlinux"

# Install MBR
echo "Installing MBR..."
dd if=/usr/lib/EXTLINUX/mbr.bin of="$LOOP_DEVICE" bs=440 count=1

# Make bootable
echo "Making partition bootable..."
fdisk "$LOOP_DEVICE" <<EOF
a
w
EOF

# Sync and finish
echo "Syncing files..."
sync

echo "Image creation complete: $IMAGE_NAME"
echo "You can now flash this image to a CF card with:"
echo "  dd if=$IMAGE_NAME of=/dev/hdaX bs=4M status=progress"
echo "Note: ensure extlinux.conf uses the correct boot drive (default: /dev/hda)"
