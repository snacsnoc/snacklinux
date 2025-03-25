# Networking Setup in SnackLinux

This guide provides instructions for setting up networking in SnackLinux, including configuring interfaces, setting up Wi-Fi connections, and troubleshooting common network issues.

## Table of Contents

1. [Configuring Network Interfaces](#configuring-network-interfaces)
2. [Setting Up Wi-Fi Connections](#setting-up-wi-fi-connections)
3. [Static IP Configuration](#static-ip-configuration)
4. [DHCP Configuration](#dhcp-configuration)
5. [DNS Configuration](#dns-configuration)
6. [Troubleshooting Common Network Issues](#troubleshooting-common-network-issues)

## Configuring Network Interfaces

SnackLinux uses the standard Linux networking tools for interface configuration. To view your network interfaces, use the following command:

```bash
ip link show
```

To bring up or down an interface, use:

```bash
ip link set eth0 up
ip link set eth0 down
```

Replace `eth0` with your interface name.

## Setting Up Wi-Fi Connections

SnackLinux supports Wi-Fi connections using the `wpa_supplicant` utility. To set up a Wi-Fi connection:

1. Create a `wpa_supplicant.conf` file:

```bash
nano /etc/wpa_supplicant/wpa_supplicant.conf
```

2. Add your network configuration:

```
network={
    ssid="YourNetworkName"
    psk="YourPassword"
}
```

3. Start the `wpa_supplicant` service:

```bash
wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf
```

Replace `wlan0` with your wireless interface name.

## Static IP Configuration

To set a static IP address, edit the `/etc/network/interfaces` file:

```bash
nano /etc/network/interfaces
```

Add the following configuration:

```
auto eth0
iface eth0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
```

Adjust the IP addresses according to your network setup.

## DHCP Configuration

For DHCP configuration, edit the `/etc/network/interfaces` file:

```bash
nano /etc/network/interfaces
```

Add the following configuration:

```
auto eth0
iface eth0 inet dhcp
```

## DNS Configuration

To configure DNS, edit the `/etc/resolv.conf` file:

```bash
nano /etc/resolv.conf
```

Add your DNS servers:

```
nameserver 8.8.8.8
nameserver 8.8.4.4
```

## Troubleshooting Common Network Issues

1. **No network connectivity:**
   - Check if the interface is up: `ip link show`
   - Verify IP address assignment: `ip addr show`
   - Test network connectivity: `ping 8.8.8.8`

2. **DNS resolution issues:**
   - Check `/etc/resolv.conf` for proper DNS server entries
   - Test DNS resolution: `nslookup example.com`

3. **Wi-Fi connection problems:**
   - Verify `wpa_supplicant` is running: `ps aux | grep wpa_supplicant`
   - Check Wi-Fi interface status: `iwconfig`
   - Review `wpa_supplicant` logs: `journalctl -u wpa_supplicant`

For more advanced networking configurations or issues, consult the SnackLinux community forums or refer to the Linux kernel documentation.