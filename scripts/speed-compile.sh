#!/usr/bin/env bash
# speed-compile.sh - Ahead-of-Time compile critical apps into native ARM64 machine code
set -e

core_apps=(
  com.oppo.launcher
  com.android.systemui
  com.google.android.inputmethod.latin
  com.whatsapp
  com.phonepe.app
  net.sourceforge.opencamera
)

echo "Compiling core apps to native machine code (-m speed)..."
for app in "${core_apps[@]}"; do
  echo "Compiling $app..."
  adb shell cmd package compile -m speed -f "$app" && echo "✔ Successfully compiled: $app"
done

echo "AOT compilation complete!"
