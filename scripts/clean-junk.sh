#!/usr/bin/env bash
# clean-junk.sh - Clean safe caches, thumbnail dumps, and trim app memory caches
set -e

echo "Cleaning WhatsApp temporary chunks..."
adb shell "rm -rf /sdcard/WhatsApp/.Shared/* 2>/dev/null || true"

echo "Cleaning redundant WhatsApp daily backups (preserving active msgstore.db.crypt14)..."
adb shell "find /sdcard/WhatsApp/Databases/ -type f -name 'msgstore-20*.crypt14' -delete 2>/dev/null || true"

echo "Cleaning Gallery thumbnails & trash..."
adb shell "rm -rf /sdcard/DCIM/.thumbnails/* 2>/dev/null || true"
adb shell "rm -rf /sdcard/.ColorOSGalleryRecycler/* 2>/dev/null || true"

echo "Cleaning WhatsApp status video cache..."
adb shell "rm -rf /sdcard/WhatsApp/Media/.Statuses/* 2>/dev/null || true"
adb shell "rm -rf /sdcard/WhatsApp/Media/.trash/* 2>/dev/null || true"

echo "Trimming Android app caches..."
adb shell "pm trim-caches 4096M 2>/dev/null || true"

echo "Junk cleanup complete!"
