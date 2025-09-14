---
author: acrogenesis
comments: true
date: 2014-01-07 17:46:03+00:00
layout: AcrogenesisCom.PostLayout
slug: how-to-bypass-hotspot-logins
title: How to Bypass Hotspot logins on a mac
wordpress_id: 57
categories:
- How-To
permalink: /:title/
---

If you are reading this you have probably faced a Hotspot at an airport, hotel, cafe etc. where the WiFi access was open but you faced a Hotspot login portal asking you to agree terms & conditions or pay a fee.

Luckily there's an easy way around this which is based on how the portal allows some devices in and the other not.

Every device that connects to a network has a [MAC](https://en.wikipedia.org/wiki/MAC_address) address this address is embedded in your device and is unique. This is what the Hotspot checks to see if you are allowed to access the internet or not.

What we are going to do is called '[MAC Address Spoofing](https://en.wikipedia.org/wiki/MAC_spoofing)'. Doing this will help us impersonate another device on the network which hopefully does have internet access.

Open Terminal

We need the MAC address we are going to impersonate. To get all MAC address in you ARP cache run


```bash
arp -na | sort -u -t' ' -k4,4
```


This will give you a list of ip address with their corresponding MAC addresses. Save this list we will be using it later.

Now we have to change our MAC address to one of the list and luckily will get internet access. To change(spoof) your MAC address run


```bash
sudo ifconfig en0 ether 00:00:00:00:00:00
```


where 00:00... is the MAC address to spoof.

Now just turn off and on your WiFi try and access [http://acrogenesis.com](http://acrogenesis.com) if you face a Hotspot login try another MAC address from the list, if not you are already connected to the internet!

If running arp -na didn't give you results or the MAC addresses you tried didn't give you internet connectivity you will have to ping all devices with nmap here is how to do it:

To ping all devices on the network with nmap you need to have installed nmap on your mac the easiest way is thru [brew](http://brew.sh/) which if you don't have installed you have to install it to.

After installing brew  run


```bash
brew install nmap
```


Now we need to know which addresses and netmask we are going to ping. So run


```bash
ifconfig | grep inet
```


and look for one that starts with 192.168.X.X, 172.X.X.X or 10.X.X.X like:


```bash
inet 192.168.2.156 netmask 0xffffff00 broadcast 192.168.2.255
```


To convert the hexadecimal netmask to decimal look it up at [http://www.pawprint.net/designresources/netmask-converter.php](http://www.pawprint.net/designresources/netmask-converter.php)

Mine is /24

Now let's ping all the devices, depending on the address and netmask you got is what you will ping.

Examples:

For 192.168.2.156 netmask 24


```bash
nmap -sn 192.168.2.0/24
```


for 172.16.0.156 netmask 16


```bash
nmap -sn 172.16.0.0/16
```


for 10.5.4.2 netmask 8


```bash
nmap -sn 10.0.0.0/8
```


Now run again


```bash
arp -na | sort -u -t' ' -k4,4
```


The list will now have all devices connected to the network.
