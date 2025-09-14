---
layout: AcrogenesisCom.PostLayout
title: "How to Fix Print Screen on Mac Keyboards in Omarchy"
slug: "how-to-fix-print-screen-on-mac-keyboards-in-omarchy"
date: "2025-08-29"
author: acrogenesis
comments: true
permalink: /:title/
---

You've just set up your sleek new Omarchy system, and you plug in your favorite keyboard, like a Keychron. You flip it into "Mac mode" because the keycaps match your layout, but when you press the Print Screen key... the app moves to a new screen.

[TL;DR](#step-4-write-the-remapping-rule)

## The Problem: When a Key Isn't Just a Key

The first step in fixing a problem is understanding it. In our case, the Print Screen key on a Keychron K3 in "Mac mode" wasn't sending a simple `Print` signal. To figure out what it *was* sending, we used `keyd`'s built-in diagnostic tool.

After installing `keyd`, we ran its monitor command (`sudo keyd monitor`). When we pressed the problematic key, the monitor showed us the truth: a single press was sending a sequence of **three keys at once**: `leftshift`, `leftmeta`, and `4`.

This is the standard macOS shortcut to take a screenshot of a selected area. The keyboard's firmware was literally typing a Mac shortcut, which our Linux system didn't know what to do with.

-----

## The Solution: `keyd`, the Universal Translator

Simple remapping tools couldn't fix this, as they struggled to intercept a multi-key combination. The solution was to use **`keyd`**, a powerful, low-level daemon that can remap keys and combinations before your desktop environment even sees them.

Here’s how we used it to translate the macOS shortcut into a proper `Print Screen` event.

### Step 1: Install and Enable `keyd`

First, we installed `keyd` and enabled its background service.

```bash
sudo pacman -S keyd
sudo systemctl enable --now keyd
```

### Step 2: Get Your Keyboard's Info with `keyd monitor`

Next, we need to find the keyboard's hardware ID and diagnose the key press. The `keyd monitor` command does both at the same time.

```bash
sudo keyd monitor
```

The monitor will list all connected devices. Look for your keyboard in the list. The output will look like this:

```bash
device added: 05ac:024f:f110753b Keychron Keychron K3 (/dev/input/event4)
```

From this single line, we get the **vendor and product ID**: **`05ac:024f`**.

With the monitor still running, press the problematic key to confirm what it sends.

### Step 3: Create the Configuration File

Now, create a configuration file in `/etc/keyd/`. It's good practice to name it after the device.

```bash
sudo nvim /etc/keyd/your-keyboard.conf
```

### Step 4: Write the Remapping Rule

This is where the magic happens. Inside the file, we set up two sections:

* `[ids]`: Tells `keyd` which device(s) this rule applies to. We use the ID from `keyd monitor`.
* `[main]`: Defines the actual remapping.

We tell `keyd` to look for the `leftmeta+leftshift+4` combination and replace it with `sysrq`, which is the kernel's internal name for the Print Screen key.

```ini
# /etc/keyd/your-keyboard.conf
# (Run: sudo keyd monitor to discover <vendor>:<product> and the exact combo)

[ids]
<vendor>:<product>    # optional – delete this whole block to apply globally

[main]
leftmeta+leftshift+4 = sysrq
```

### Step 5: Reload and Test

With the configuration saved, a final command applies the changes without needing a reboot:

```bash
sudo keyd reload
```

And just like that, the Print Screen key will start working perfectly, triggering all the screenshot hotkeys already configured on your system.

-----

## Why This Works

This method is so effective because `keyd` works at a very low level. It intercepts the raw input from the keyboard, finds a match in your configuration, and sends a new, corrected event to the rest of the OS. To your desktop and all other applications, it looks as if you pressed a normal Print Screen key all along.
