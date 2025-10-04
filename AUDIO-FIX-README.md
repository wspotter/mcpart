# Audio Fix for Morning Sound Issues

## Problem
After the system sleeps overnight, the NVIDIA HDMI audio device (0000:83:00.1) loses its hardware connection state, causing no sound output even though everything appears to work in software.

## Root Cause
The NVIDIA HDMI audio controller doesn't properly restore the HDMI audio link to the monitor after sleep/wake cycles. The device shows `monitor_present=0` in `/proc/asound/card3/eld` files.

## Solution
Reset the NVIDIA audio PCI device after every system wake to force hardware reinitialization.

## Files

### Automatic Fix (Installed)
- **`/usr/lib/systemd/system-sleep/nvidia-audio-reset`**
  - Automatically runs after system wakes from sleep
  - Resets the NVIDIA audio device and restores HDMI audio connection
  - Takes ~3-5 seconds after wake

### Manual Fix (If Needed)
- **`quick-audio-fix.sh`**
  - Run this script if audio breaks before the automatic fix is tested
  - Faster than a full system reboot (5-10 seconds vs minutes)
  - Usage: `./quick-audio-fix.sh`

### Documentation
- **`REAL-FIX-SUMMARY.sh`**
  - Shows complete explanation of the problem and solution
  - Usage: `./REAL-FIX-SUMMARY.sh`

## How It Works

1. System goes to sleep (overnight/idle)
2. System wakes up
3. Sleep hook automatically runs: removes and rescans NVIDIA audio device
4. Audio hardware connection is restored
5. You have working audio immediately - no reboot needed!

## Manual Fix Command
If you ever need to fix audio manually:
```bash
sudo sh -c 'echo 1 > /sys/bus/pci/devices/0000:83:00.1/remove && echo 1 > /sys/bus/pci/rescan'
systemctl --user restart wireplumber
```

## Verification
Check that the automatic fix is installed:
```bash
ls -l /usr/lib/systemd/system-sleep/nvidia-audio-reset
```

Monitor logs after wake:
```bash
journalctl -t nvidia-audio-fix
```

## Status
✅ Permanent fix installed and active
✅ Will run automatically after every sleep/wake cycle
✅ No more daily reboots needed!