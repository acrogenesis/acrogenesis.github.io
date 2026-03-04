---
layout: AcrogenesisCom.PostLayout
title: "Omarchy: Enable Notification Sound in mako"
slug: "omarchy-enable-notification-sound-in-mako"
date: "2026-02-18"
author: acrogenesis
comments: true
permalink: /:slug
---

Omarchy uses `mako` for notifications. By default, you may have visual popups with no sound. This setup adds a sound on every shown notification, and keeps the change across theme switches.

If your first notification after idle is still clipped or silent on HDMI, see:

[How to Fix HDMI First-Notification Clipping in Omarchy (mako)](/omarchy-fix-hdmi-first-notification-clipping-in-mako)

## 1) Create a notification sound script

```bash
mkdir -p ~/.local/bin
cat > ~/.local/bin/omarchy-notification-sound <<'BASH'
#!/bin/bash

# Optional custom sound:
# ~/.local/share/sounds/notification.oga

custom_sound="${XDG_DATA_HOME:-$HOME/.local/share}/sounds/notification.oga"
default_sound="/usr/share/sounds/freedesktop/stereo/message.oga"

if [[ -f "$custom_sound" ]]; then
  if command -v paplay >/dev/null 2>&1; then
    paplay "$custom_sound" >/dev/null 2>&1 &
    exit 0
  fi
  if command -v pw-play >/dev/null 2>&1; then
    pw-play "$custom_sound" >/dev/null 2>&1 &
    exit 0
  fi
fi

if [[ -f "$default_sound" ]]; then
  if command -v paplay >/dev/null 2>&1; then
    paplay "$default_sound" >/dev/null 2>&1 &
    exit 0
  fi
  if command -v pw-play >/dev/null 2>&1; then
    pw-play "$default_sound" >/dev/null 2>&1 &
    exit 0
  fi
fi

if command -v canberra-gtk-play >/dev/null 2>&1; then
  canberra-gtk-play -i message -d mako >/dev/null 2>&1 &
fi
BASH
chmod +x ~/.local/bin/omarchy-notification-sound
```

## 2) Tell mako to run it on each notification

Omarchy links your live `mako` config to:

```bash
~/.config/omarchy/current/theme/mako.ini
```

Add:

```ini
on-notify=exec ~/.local/bin/omarchy-notification-sound
```

If an app already plays its own sound (for example Slack), exclude it to avoid double audio:

```ini
[app-name=Slack]
on-notify=none
```

Reload:

```bash
makoctl reload
```

Test:

```bash
notify-send "Test" "Notification sound check"
```

## 3) Native sound options you can use

Common event IDs from the built-in Freedesktop theme:

- `message`
- `message-new-instant`
- `dialog-information`
- `dialog-warning`
- `dialog-error`
- `complete`
- `bell`
- `camera-shutter`
- `device-added`
- `device-removed`
- `network-connectivity-established`
- `network-connectivity-lost`
- `phone-incoming-call`
- `power-plug`
- `power-unplug`
- `service-login`
- `service-logout`
- `window-attention`
- `trash-empty`

Try a sound by event ID:

```bash
canberra-gtk-play -i message -d mako
canberra-gtk-play -i complete -d mako
```

List all local sound IDs dynamically:

```bash
ls /usr/share/sounds/freedesktop/stereo | sed 's/\.oga$//'
```

## 4) Keep the setting after theme changes

Omarchy rewrites theme files when you switch themes. Re-apply the `on-notify` line with a hook.

Create `~/.config/omarchy/hooks/theme-set`:

```bash
#!/bin/bash
set -euo pipefail

mako_theme="$HOME/.config/omarchy/current/theme/mako.ini"
sound_rule='on-notify=exec ~/.local/bin/omarchy-notification-sound'
slack_app='[app-name=Slack]'
slack_rule='on-notify=none'

if [[ -f "$mako_theme" ]] && ! grep -Fxq "$sound_rule" "$mako_theme"; then
  printf '\n%s\n' "$sound_rule" >> "$mako_theme"
fi

if [[ -f "$mako_theme" ]] && ! awk '
  /^\[app-name=Slack\]$/ {
    getline
    if ($0 == "on-notify=none") found=1
  }
  END { exit(found ? 0 : 1) }
' "$mako_theme"; then
  printf '\n%s\n%s\n' "$slack_app" "$slack_rule" >> "$mako_theme"
fi

makoctl reload >/dev/null 2>&1 || true
```

Then:

```bash
chmod +x ~/.config/omarchy/hooks/theme-set
```

At this point notification sound is wired. If HDMI still clips the first one after idle, use the dedicated HDMI fix post linked above.
