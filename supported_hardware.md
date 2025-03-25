# Supported Hardware

This document provides information on the hardware supported by SnackLinux, including compatible CPUs, minimum RAM requirements, and supported storage devices.

## CPUs

SnackLinux is designed to run on x86 architecture, with a focus on older systems. The following CPU types are supported:

- i486 and later x86 processors
- x86_64 (64-bit) processors (not actively maintained, but functional)

### Minimum CPU Requirements

- Architecture: x86 (32-bit) or x86_64 (64-bit)
- Instruction set: i486 or later
- Clock speed: No specific minimum, but faster is better for improved performance

## RAM

SnackLinux is designed to run with minimal memory requirements:

- Minimum RAM: 8 MB
- Recommended RAM: 16 MB or more

Note: While SnackLinux can run with as little as 8 MB of RAM, more memory will allow for better performance and the ability to run additional applications.

## Storage Devices

SnackLinux supports a variety of storage devices:

### Hard Disk Drives (HDD)

- IDE/PATA drives
- SATA drives (via AHCI controller)

### Solid State Drives (SSD)

- SATA SSDs

### Removable Storage

- USB flash drives
- Compact Flash cards (using IDE adapters)

### Optical Drives

- CD-ROM drives (for booting from live CD)

## Network Interfaces

SnackLinux supports a wide range of network interfaces, including:

- Ethernet adapters (various chipsets supported)
- Some wireless adapters (limited support, may require additional drivers)

## Graphics

SnackLinux uses a text-based interface by default, which is compatible with most basic VGA adapters. For systems with more advanced graphics capabilities, the following are supported:

- Basic VGA adapters
- VESA-compatible graphics adapters

## Other Hardware Considerations

- BIOS: Standard PC BIOS
- Boot: Supports booting from various devices (HDD, USB, CD-ROM)
- Input devices: Standard keyboard and mouse support

## Hardware Detection

SnackLinux uses a minimal set of kernel modules and relies on automatic hardware detection during boot. This allows it to work on a wide range of hardware configurations without requiring manual driver installation in most cases.

## Unsupported Hardware

While SnackLinux aims to support a wide range of hardware, some modern hardware features may not be supported due to the focus on older systems and minimal resource usage. This includes:

- UEFI-only systems (Legacy BIOS mode is required)
- Very recent CPU architectures and features
- Advanced GPU features

## Testing Your Hardware

To determine if your hardware is compatible with SnackLinux:

1. Download the SnackLinux ISO image
2. Create a bootable USB drive or CD
3. Boot your system from the SnackLinux media
4. If the system boots successfully and you can access a command prompt, your hardware is likely compatible

For any hardware-related issues or questions, please refer to the SnackLinux community forums or documentation for troubleshooting steps and additional information.