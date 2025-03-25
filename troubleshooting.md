# Troubleshooting Guide for SnackLinux

This guide covers common issues you might encounter while using SnackLinux and provides solutions to help you resolve them.

## Table of Contents

1. [Boot Problems](#boot-problems)
2. [Hardware Compatibility Issues](#hardware-compatibility-issues)
3. [Package Management Errors](#package-management-errors)
4. [Kernel-related Issues](#kernel-related-issues)
5. [System Performance](#system-performance)

## Boot Problems

### Issue: SnackLinux fails to boot

1. **Check your bootloader configuration:**
   Ensure that your `isolinux.cfg` file in the `boot/isolinux/` directory is correctly configured. Look for any typos or incorrect paths.

2. **Verify kernel and initrd paths:**
   Make sure the kernel (`bzImage` for x86/i486 or `Image` for arm64) and `rootfs.gz` are present in the correct locations.

3. **BIOS settings:**
   For older hardware, ensure that your BIOS settings are compatible with SnackLinux. Try disabling ACPI and APIC:

   ```
   APPEND root=/dev/ram rdinit=/sbin/init noacpi noapic
   ```

4. **Use verbose boot mode:**
   Add `debug` to your kernel command line to get more detailed boot information:

   ```
   APPEND root=/dev/ram rdinit=/sbin/init debug
   ```

## Hardware Compatibility Issues

### Issue: Network interfaces not detected

1. **Check for kernel module:**
   Ensure that the appropriate kernel module for your network card is built into the kernel or available as a loadable module.

2. **Manually load the module:**
   If the module is available but not loaded, try loading it manually:

   ```
   modprobe <module_name>
   ```

3. **Compile custom kernel:**
   If your hardware is not supported by the default kernel, you may need to compile a custom kernel with the required drivers. Refer to the [Compiling SnackLinux from source](http://snacklinux.geekness.eu/getting-started) section in the documentation.

### Issue: Graphics not working correctly

1. **Use basic VGA mode:**
   Add `vga=normal` to your kernel command line for basic graphics compatibility:

   ```
   APPEND root=/dev/ram rdinit=/sbin/init vga=normal
   ```

2. **Check for framebuffer support:**
   Ensure that framebuffer support is enabled in your kernel configuration if you need more advanced graphics capabilities.

## Package Management Errors

### Issue: Unable to install packages with fbpkg

1. **Check internet connectivity:**
   Ensure that your system has a working internet connection.

2. **Verify package repository:**
   Make sure the package repository URL in fbpkg's configuration is correct and accessible.

3. **Update package list:**
   Try updating the package list before installing:

   ```
   fbpkg update
   ```

4. **Check available space:**
   Ensure you have enough free space in your root filesystem:

   ```
   df -h
   ```

5. **Manually download and install:**
   If fbpkg fails, try manually downloading the package and installing it:

   ```
   wget <package_url>
   tar xvf <package_file>
   cp -R <extracted_files> /
   ```

## Kernel-related Issues

### Issue: Kernel panic during boot

1. **Use an earlier kernel version:**
   If you recently updated the kernel, try booting with an earlier version if available.

2. **Check for hardware conflicts:**
   Disable potentially conflicting hardware in BIOS or remove recently added hardware.

3. **Rebuild the kernel:**
   If you're using a custom kernel, double-check your configuration and rebuild:

   ```
   make kernel
   make kernel-install
   ```

4. **Use fallback initramfs:**
   If available, try booting with a fallback initramfs that contains basic drivers and modules.

## System Performance

### Issue: System running slowly

1. **Check resource usage:**
   Use `top` or `htop` to identify resource-hungry processes.

2. **Optimize kernel:**
   If you compiled your own kernel, ensure you've only included necessary modules and features.

3. **Use lighter alternatives:**
   Consider using lighter alternatives for system services and applications.

4. **Adjust swappiness:**
   If you have limited RAM, adjust the swappiness value:

   ```
   echo 10 > /proc/sys/vm/swappiness
   ```

5. **Optimize filesystem:**
   Use `e2fsck` and `tune2fs` to check and optimize your filesystem:

   ```
   e2fsck -f /dev/sdXY
   tune2fs -O ^has_journal /dev/sdXY
   ```

Remember that SnackLinux is designed for minimal systems, so performance issues might also be related to hardware limitations.

For further assistance, consult the [SnackLinux website](http://snacklinux.geekness.eu) or reach out to the community for support.