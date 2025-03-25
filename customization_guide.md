# SnackLinux Customization Guide

This guide explains how to customize your SnackLinux installation, including adding or removing packages, modifying kernel options, and creating custom images.

## Table of Contents

1. [Adding and Removing Packages](#adding-and-removing-packages)
2. [Modifying Kernel Options](#modifying-kernel-options)
3. [Creating Custom Images](#creating-custom-images)

## Adding and Removing Packages

SnackLinux uses a minimal set of packages by default. To customize your installation, you can add or remove packages as needed.

### Adding Packages

To add a new package to your SnackLinux installation:

1. Locate the package source code or binary.
2. Add the package to the build process by modifying the `Makefile`.
3. Create a new target for the package, following the existing patterns.

Example for adding a new package called `newpackage`:

```makefile
newpackage:
    cd newpackage/ ; \
    CROSS_COMPILE=$(TARGET)-linux-musl- \
    ./configure --prefix=/ ; \
    $(MAKE) -j$(JOBS)

newpackage-install: newpackage
    cd newpackage/ ; \
    $(MAKE) DESTDIR=$(ROOTFS_PATH) install
```

4. Add the new package to the `system` target in the `Makefile`:

```makefile
system: musl busybox bash newpackage
```

### Removing Packages

To remove a package from your SnackLinux installation:

1. Remove the package's build and install targets from the `Makefile`.
2. Remove the package from the `system` target in the `Makefile`.
3. Delete the package's source code directory if it's no longer needed.

## Modifying Kernel Options

To customize the kernel configuration:

1. Locate the appropriate kernel configuration file in the `configs/linux/` directory (e.g., `.config-i486` for i486 architecture).
2. Edit the configuration file to enable or disable kernel options as needed.
3. Rebuild the kernel using the `make kernel` command.

Example of enabling a kernel option:

```
CONFIG_SOME_FEATURE=y
```

Example of disabling a kernel option:

```
# CONFIG_SOME_FEATURE is not set
```

After modifying the kernel configuration, rebuild the kernel:

```bash
make kernel
make kernel-install
```

## Creating Custom Images

SnackLinux provides a script to create bootable CF card images for i486 systems. You can customize this process to create images tailored to your needs.

### Customizing the Image Creation Script

The image creation script is located at `tools/build_bootable_img.sh`. You can modify this script to change various aspects of the image creation process:

1. **Image Size**: Modify the `IMAGE_SIZE` variable to change the size of the created image.

```bash
IMAGE_SIZE=450  # Size in MB
```

2. **Filesystem Type**: The script currently uses ext2. To use a different filesystem, modify the `mkfs` command:

```bash
mkfs.ext4 "${LOOP_DEVICE}p1"  # Change to ext4
```

3. **Boot Loader**: The script uses extlinux. If you want to use a different boot loader, modify the relevant sections of the script.

### Creating a Custom Image

To create a custom image:

1. Modify the `build_bootable_img.sh` script as needed.
2. Ensure your custom packages and configurations are in place.
3. Run the script as root:

```bash
sudo ./tools/build_bootable_img.sh
```

4. The script will create a bootable image file that you can flash to a CF card or use in a virtual machine.

Remember to test your custom image thoroughly before deploying it to actual hardware.

## Conclusion

By following this guide, you should now be able to customize your SnackLinux installation to suit your specific needs. Whether you're adding new packages, tweaking the kernel, or creating custom images, these techniques will help you tailor SnackLinux to your requirements.

For more advanced customizations or specific questions, please refer to the SnackLinux documentation or reach out to the community for support.