#!/bin/bash
# Quick audio fix - run this instead of rebooting if audio breaks

echo "🔧 Resetting NVIDIA audio device..."

sudo sh -c 'echo 1 > /sys/bus/pci/devices/0000:83:00.1/remove'
sleep 1
sudo sh -c 'echo 1 > /sys/bus/pci/rescan'
sleep 2

echo "♻️  Restarting audio services..."
systemctl --user restart wireplumber
sleep 2

echo "🎵 Testing audio..."
paplay /usr/share/sounds/alsa/Front_Center.wav 2>/dev/null

if wpctl status >/dev/null 2>&1; then
    echo "✅ Audio is working!"
else
    echo "⚠️  Audio may still have issues. Try again or reboot."
fi