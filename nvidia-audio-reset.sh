#!/bin/bash
# NVIDIA Audio Reset - The actual fix for your morning audio problem
# This script resets the NVIDIA HDMI audio PCI device

NVIDIA_AUDIO_DEVICE="0000:83:00.1"

case "$1" in
    post)
        # After system wake - reset the NVIDIA audio device
        echo "$(date): System woke up, resetting NVIDIA audio device..." | systemd-cat -t nvidia-audio-fix
        
        # Wait for system to stabilize
        sleep 3
        
        # Reset the NVIDIA audio PCI device
        echo 1 > /sys/bus/pci/devices/${NVIDIA_AUDIO_DEVICE}/remove
        sleep 1
        echo 1 > /sys/bus/pci/rescan
        sleep 2
        
        echo "$(date): NVIDIA audio device reset complete" | systemd-cat -t nvidia-audio-fix
        ;;
esac