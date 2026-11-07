#!/usr/bin/env bash
# restrict-background.sh - Restrict 3rd party apps in background while preserving WhatsApp & PhonePe
set -e

echo "Applying AppOps background execution policies..."
packages=$(adb shell pm list packages -3 | cut -d: -f2)

for pkg in $packages; do
  if [ "$pkg" = "com.whatsapp" ] || [ "$pkg" = "com.phonepe.app" ]; then
    echo "✔ Keeping active: $pkg"
    adb shell cmd appops set "$pkg" RUN_IN_BACKGROUND allow
    adb shell cmd appops set "$pkg" RUN_ANY_IN_BACKGROUND allow
  else
    echo "🔒 Restricting background: $pkg"
    adb shell cmd appops set "$pkg" RUN_IN_BACKGROUND ignore
    adb shell cmd appops set "$pkg" RUN_ANY_IN_BACKGROUND ignore
    adb shell am force-stop "$pkg" 2>/dev/null || true
  fi
done

echo "Background policy configuration complete!"
