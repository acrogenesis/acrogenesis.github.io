---
layout: AcrogenesisCom.PostLayout
title: "Remote Access to Omarchy (Hyprland on Arch) with wayvnc and Tailscale"
slug: "remote-access-to-omarchy-with-wayvnc-and-tailscale"
date: "2025-09-16"
author: acrogenesis
comments: true
permalink: /:slug
---

[Omarchy](https://omarchy.org) (Hyprland on Arch) is a fast, lightweight tiling Wayland environment—perfect for your main PC setup. But what if you want to access your Omarchy machine while on the go, using your MacBook Pro or another device? With [wayvnc](https://github.com/any1/wayvnc) and [Tailscale](https://tailscale.com/), you can connect securely from anywhere and even make the experience usable on different resolution devices like a MacBook Pro.

This post walks you through the setup: installing wayvnc and Tailscale, handling resolution toggling for ultrawide monitors, and connecting from macOS.

## Step 1: Install wayvnc and Tailscale

On your Omarchy (or Hyprland on Arch) machine:

**For Tailscale, the recommended way is to use the Omarchy menu:**

> **Menu:** Install → Service → Tailscale

This will handle the installation and setup for you.

**For wayvnc, or if you prefer the terminal:**

```bash
yay -S wayvnc tailscale
```

Enable and start Tailscale:

```bash
sudo systemctl enable --now tailscaled
sudo tailscale up
```

Tailscale gives you a secure private IP (something like 100.x.y.z) that works anywhere, without opening firewall ports.

## Step 2: Find Your Monitor Name and Resolution

On your Omarchy (Hyprland) machine, open a terminal and run:

```bash
hyprctl monitors
```

This will list all connected monitors, their names (e.g., `DP-3`), and their current resolutions (e.g., `5120x1440@240`). Note your main monitor's name and its native resolution.

## Step 3: Find Your Client (Mac) Resolution and Customize the Toggle Script

On your Mac, open Terminal and run:

```bash
system_profiler SPDisplaysDataType | grep Resolution
```

This will output something like:

```text
Resolution: 3456 x 2234 Retina
```

For Retina displays, divide both numbers by 2 to get the actual pixel resolution. For example, `3456 / 2 = 1728` and `2234 / 2 ≈ 1117`, so use `1728x1117`.

Now, create `~/toggle-resolution.sh` on your Omarchy machine, customizing the monitor name and resolutions for your setup. Here’s my example for a Samsung Odyssey G9 (5120x1440) and a MacBook Pro 16" M1 (1728x1117):

```bash
#!/bin/bash
MONITOR="DP-3"

CURRENT=$(hyprctl monitors | awk -v mon="$MONITOR" '
    $2 == mon {getline; print $1}' )

if [[ "$CURRENT" == 5120x1440* ]]; then
    echo "Switching to MacBook-friendly resolution (1728x1117@60)..."
    hyprctl keyword monitor "$MONITOR,1728x1117@60,0x0,1"
elif [[ "$CURRENT" == 1728x1117* ]]; then
    echo "Switching back to Odyssey G9 native resolution (5120x1440@240)..."
    hyprctl keyword monitor "$MONITOR,5120x1440@240,0x0,1"
else
    echo "Current mode is $CURRENT — defaulting to Odyssey G9 native."
    hyprctl keyword monitor "$MONITOR,5120x1440@240,0x0,1"
fi
```

Make it executable:

```bash
chmod +x ~/toggle-resolution.sh
```

(Optional) Add a Hyprland keybinding in `~/.config/hypr/bindings.conf`:

```ini
bindd = SUPER SHIFT, R, Toggle Resolution, exec, ~/toggle-resolution.sh
```

Now you can switch between ultrawide native and MacBook-friendly resolution with a hotkey or by running the script directly.

## Step 4: Connect from macOS

On your Mac:

1. Install a VNC client on your Mac (e.g. TigerVNC Viewer or RealVNC Viewer).
2. On your Mac, click the Tailscale icon in the top bar, find your Omarchy machine in the device list, and click it this copies its Tailscale IP address to your clipboard.
3. Open your VNC viewer and connect to your Omarchy’s IP (e.g. 100.115.92.30:5900).
4. If needed, use your toggle script (or hotkey) to adjust the remote resolution for your Mac’s screen.

## Conclusion

With Omarchy (Hyprland on Arch), wayvnc, and Tailscale, you can have a secure, practical remote desktop setup. Add a simple resolution toggle script, and you’ll have the flexibility to use an ultrawide monitor at your desk and a laptop-friendly resolution when you connect remotely.
