# Getting Started with SnackLinux

SnackLinux is an ultra-minimal Linux distribution designed for 486 CPUs and systems with limited resources. This guide will help you get started with SnackLinux, covering system requirements, download instructions, installation process, and basic usage.

## System Requirements

- CPU: 486 or better
- RAM: 8MB minimum
- Storage: Compact Flash card or hard drive (size depends on your needs, but a few hundred MB should be sufficient)

## Downloading SnackLinux

You can download SnackLinux in two formats:

1. Pre-built ISO image
2. Flashable disk image for Compact Flash cards

To download the latest version of SnackLinux, visit the official website:

[http://snacklinux.geekness.eu](http://snacklinux.geekness.eu)

Look for the "Downloads" section and choose the appropriate image for your needs.

## Installation

### Using the ISO image

1. Burn the ISO image to a CD or create a bootable USB drive using a tool like Rufus or dd.
2. Boot your target system from the CD or USB drive.
3. Follow the on-screen instructions to install SnackLinux to your desired storage device.

### Using the flashable disk image

1. Download the flashable disk image (e.g., `snacklinux_cf_i486_DD.MM.YY.img`).
2. Connect your Compact Flash card to your computer using an appropriate adapter.
3. Flash the image to the CF card using a tool like `dd` on Linux/macOS or Win32DiskImager on Windows.

   Example using dd (replace `X` with the appropriate device letter):
   ```
   sudo dd if=snacklinux_cf_i486_DD.MM.YY.img of=/dev/sdX bs=4M status=progress
   ```

4. Insert the CF card into your target system and boot from it.

## First Boot and Basic Usage

1. On first boot, SnackLinux will automatically log you in as the root user.

2. The default shell is Bash, and you'll have access to common Unix utilities provided by BusyBox.

3. To view available commands, type:
   ```
   busybox --list
   ```

4. SnackLinux uses a simple package manager called `fbpkg`. To install additional packages:
   ```
   fbpkg install <package_name>
   ```

5. To update the system:
   ```
   fbpkg update
   ```

6. To shut down the system:
   ```
   poweroff
   ```

## Customizing SnackLinux

SnackLinux is designed to be highly customizable. You can modify the root filesystem, recompile the kernel, or add your own packages. Refer to the README.md file in the SnackLinux GitHub repository for more advanced customization options.

## Getting Help

If you encounter issues or need further assistance, you can:

- Check the SnackLinux wiki at [http://snacklinux.geekness.eu](http://snacklinux.geekness.eu)
- Visit the GitHub repository at [https://github.com/snacsnoc/snacklinux](https://github.com/snacsnoc/snacklinux)
- Join the community forums or mailing lists (if available)

Remember that SnackLinux is designed for minimal systems, so some features or software you're used to in larger distributions may not be available by default. However, its lightweight nature makes it ideal for breathing new life into old hardware or for embedded projects.