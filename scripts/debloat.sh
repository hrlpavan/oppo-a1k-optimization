#!/usr/bin/env bash
# debloat.sh - Safely disable ColorOS 6 & Facebook bloatware on Oppo A1k
set -e

packages=(
  # Facebook Background Services
  com.facebook.services
  com.facebook.system
  com.facebook.appmanager

  # Oppo / NearMe Ad, Push & Telemetry Engines
  com.coloros.gamespace
  com.coloros.pictorial
  com.nearme.themestore
  com.nearme.statistics.rom
  com.oppo.logkit
  com.oppo.criticallog
  com.coloros.operationtips
  com.oppoex.afterservice
  com.coloros.smartdrive
  com.coloros.childrenspace
  com.oppo.quicksearchbox
  com.oppo.partnerbrowsercustomizations

  # Google Bloat on Low-End Devices
  com.google.ar.core
  com.google.android.apps.wellbeing
  com.google.android.feedback
  com.google.android.printservice.recommendation
)

echo "Disabling bloatware packages..."
for pkg in "${packages[@]}"; do
  if adb shell pm list packages | grep -q "^package:$pkg$"; then
    adb shell pm disable-user --user 0 "$pkg" 2>/dev/null && echo "✔ Disabled: $pkg" || true
  fi
done

# Revoke background execution for persistent Oppo store daemons
echo "Revoking background execution for Oppo market and gamecenter..."
for pkg in com.oppo.market com.nearme.gamecenter com.oppo.usercenter com.coloros.weather.service; do
  adb shell am force-stop "$pkg" 2>/dev/null || true
  adb shell cmd appops set "$pkg" RUN_IN_BACKGROUND ignore 2>/dev/null || true
  adb shell cmd appops set "$pkg" RUN_ANY_IN_BACKGROUND ignore 2>/dev/null || true
  echo "✔ Restricted background: $pkg"
done

echo "Debloat complete!"
