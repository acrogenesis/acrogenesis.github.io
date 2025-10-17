---
layout: AcrogenesisCom.PostLayout
title: "Enable secure boot on Omarchy"
slug: "enable-secure-boot-on-omarchy"
date: "2025-10-16"
author: acrogenesis
comments: true
permalink: /:slug
---

## The Omarchy + Windows Secure Boot Guide

This guide is the product of real-world troubleshooting. This was tested with Omarchy 3.0, Windows 11, and an NVIDIA GPU. Includes specifics for ASUS motherboards and NVIDIA graphics.

**Assumptions:**

* You have already installed Windows 10 or 11.
* You have successfully installed Omarchy alongside it.
* You are logged into your Omarchy desktop.

### Phase 1: BIOS Setup

Before we touch Omarchy's configuration, let's set the firmware in Setup Mode.

1. **Reboot and Enter your BIOS/UEFI.** (Usually by pressing `Del` or `F2` on startup).
2. **Disable CSM:** Navigate to the "Boot" tab and ensure `CSM (Compatibility Support Module)` is set to `Disabled`. Secure Boot requires a pure UEFI environment.
3. **Enter Setup Mode:**
   * Find the **"Secure Boot"** menu.
   * Select the option to **"Clear Secure Boot Keys"** or **"Delete All Secure Boot Variables"**.
   * **Do not** select any option to "Install default keys" afterwards.
4. **Save and Exit**, booting directly back into Omarchy.

### Phase 2: Key Management

Now, we'll install the keys for both of your operating systems.

1. **Install sbctl:**

    ```bash
    sudo pacman -S sbctl
    ```

2. **Create Keys:** This command generates your secure keys and saves them locally.

    ```bash
    sudo sbctl create-keys
    ```

3. **Enroll Your Keys (and Microsoft's):** Now, enroll the keys. The `-m` flag includes Microsoft's keys as well.

    ```bash
    sudo sbctl enroll-keys -m
    ```

4. **Sign the Limine Bootloader:** We need to sign the bootloader binary itself so the firmware will trust it.

    ```bash
    sudo sbctl sign -s /boot/EFI/limine/limine_x64.efi
    # Also sign the fallback path
    sudo sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
    ```

### Phase 3: Configuring Omarchy boot

1. **Get Your Partition IDs:** We need two unique IDs (the next step automates retrieving them):

      * **The LUKS Partition UUID:** This is the `UUID` of the physical partition labeled `crypto_LUKS` (e.g., `/dev/nvme2n1p2`).
      * **The BTRFS Root UUID:** This is the `UUID` of the filesystem *inside* the LUKS container, labeled `btrfs` and mounted at `/`.

2. **Create the Limine Configuration File:** (Remove `nvidia_drm.modeset=1` if you don't have NVIDIA)

    ```bash
    LUKS_UUID=$(lsblk -no UUID,FSTYPE | awk '$2=="crypto_LUKS"{print $1; exit}') && \
    BTRFS_UUID=$(lsblk -no UUID,FSTYPE,MOUNTPOINT | awk '$2=="btrfs" && $3=="/" {print $1; exit}') && \
    [ -n "$LUKS_UUID" ] && [ -n "$BTRFS_UUID" ] || { echo "Could not auto-detect required UUIDs" >&2; exit 1; } && \
    echo "Detected LUKS UUID: $LUKS_UUID" && echo "Detected BTRFS root UUID: $BTRFS_UUID" && \
    sudo tee /etc/default/limine <<EOF
    TARGET_OS_NAME="Omarchy"
    ESP_PATH="/boot"
    KERNEL_CMDLINE[default]="cryptdevice=UUID=$LUKS_UUID:root root=UUID=$BTRFS_UUID rootflags=subvol=@ quiet splash nvidia_drm.modeset=1"
    ENABLE_UKI=yes
    ENABLE_LIMINE_FALLBACK=yes
    FIND_BOOTLOADERS=yes
    BOOT_ORDER="*, *fallback, Snapshots"
    MAX_SNAPSHOT_ENTRIES=5
    SNAPSHOT_FORMAT_CHOICE=5
    EOF
    ```

3. **Create the Plymouth Hook File:** This tells the system to build the graphical splash screen into the boot image.

    ```bash
    sudo tee /etc/mkinitcpio.conf.d/omarchy_hooks.conf <<EOF
    HOOKS=(base udev plymouth keyboard autodetect microcode modconf kms keymap consolefont block encrypt filesystems fsck btrfs-overlayfs)
    EOF
    ```

### Phase 4: Restoring Plymouth

The Omarchy installer includes a script to set up a theme and a smooth transition to your desktop. We need to re-run its logic.

1. Find and run the script located in your user's Omarchy directory: `~/.local/share/omarchy/install/login/plymouth.sh`.

    ```bash
    chmod +x ~/.local/share/omarchy/install/login/plymouth.sh
    ~/.local/share/omarchy/install/login/plymouth.sh
    ```

### Phase 5: Going Live (Building, Signing, and Enabling)

Now we apply all our configurations.

1. **Run Limine Update:** This will read your new config files, build a new Unified Kernel Image (UKI), and `sbctl` will automatically sign it for you.

    ```bash
    sudo limine-update
    ```

    The output will confirm the UKI was created and signed. The warning about Secure Boot being disabled is normal here.

2. **Add Windows to the Boot Menu:**

    ```bash
    sudo limine-scan
    ```

    Select the number corresponding to **"Windows Boot Manager"** and press Enter.

3. **Reboot into your UEFI/BIOS.**

4. **Enable Secure Boot:** These are specific instructions for Asus but something similar should work for other motherboards.

      * Navigate to the **"Secure Boot"** menu.
      * Set `OS Type` to `Windows UEFI mode`. (This is key to making Windows report correctly while still allowing Omarchy to boot).
      * Ensure `Secure Boot Mode` is set to `Custom`.
      * Finally, set the main `Secure Boot` option to `Enabled`.
      * **Save Changes and Exit.**

### Phase 6: Verification

Your system will now boot to the Omarchy splash screen.

1. **Verify Secure Boot Status:**

      * In **Omarchy**, run `sbctl status`. It must say `Secure Boot: ✓ Enabled`.
      * Reboot and select **Windows** from the Limine menu. Open `msinfo32`. It must say `Secure Boot State: On`.
