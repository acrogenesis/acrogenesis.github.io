---
layout: AcrogenesisCom.PostLayout
title: "Omarchy: Fix HDMI First-Notification Clipping in mako"
slug: "omarchy-fix-hdmi-first-notification-clipping-in-mako"
date: "2026-02-18"
author: acrogenesis
comments: true
permalink: /:slug
---

If your notifications use sound but the first one after idle is silent (or cut off), while the second and third are fine, this is usually not a `mako` bug.

In most setups, it is HDMI audio sink auto-suspend.

## Why it happens

With PipeWire + WirePlumber, idle outputs can be suspended to save power. HDMI sinks are especially noticeable here.

When a short notification sound plays after idle:

1. The sink wakes up.
2. The stream starts immediately.
3. The beginning of the sound can be clipped during wake-up.

That is why repeated notifications a few seconds apart sound normal: the sink is already awake.

## Confirm this is your issue

Check your default sink:

```bash
pactl info | grep "Default Sink"
```

List sinks:

```bash
wpctl status
```

If your default sink is HDMI and first-hit clipping matches your symptoms, disable suspend for that sink.

## Fix: disable suspend timeout for your HDMI sink

Create a WirePlumber override:

```bash
mkdir -p ~/.config/wireplumber/wireplumber.conf.d
cat > ~/.config/wireplumber/wireplumber.conf.d/51-disable-hdmi-suspend.conf <<'CONF'
monitor.alsa.rules = [
  {
    matches = [
      {
        node.name = "alsa_output.pci-0000_01_00.1.hdmi-stereo"
      }
    ]
    actions = {
      update-props = {
        session.suspend-timeout-seconds = 0
      }
    }
  }
]
CONF
```

Restart user audio services:

```bash
systemctl --user restart wireplumber pipewire pipewire-pulse
```

Verify:

```bash
wpctl inspect @DEFAULT_AUDIO_SINK@ | grep session.suspend-timeout-seconds
```

Expected:

```text
session.suspend-timeout-seconds = "0"
```

## Notes

- Replace `node.name` with your actual sink name if different.
- You can get exact node names from `wpctl inspect <sink-id>`.
- If you still hear clipping, verify the fix applied to the active default sink and confirm `session.suspend-timeout-seconds = "0"` on that sink.

For the base notification-sound setup in `mako`, see:

[Omarchy: Enable Notification Sound in mako](/omarchy-enable-notification-sound-in-mako)
