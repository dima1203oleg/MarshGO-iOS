#!/usr/bin/env bash
set -euo pipefail

SIMULATOR_UDID="${SIMULATOR_UDID:-}"
if [[ -z "$SIMULATOR_UDID" ]]; then
  echo "Set SIMULATOR_UDID to an available iOS Simulator device." >&2
  exit 2
fi
if [[ ! -d web ]]; then
  npm run site:checkout
fi
if [[ -z "${VITE_API_BASE_URL:-}" ]]; then
  echo "Set VITE_API_BASE_URL to the HTTPS/local MARSHGO Server URL before producing a usable app bundle." >&2
  exit 2
fi
SETTLE_SECONDS="${SIMULATOR_SETTLE_SECONDS:-20}"
if [[ ! "$SETTLE_SECONDS" =~ ^[0-9]+$ ]] || (( SETTLE_SECONDS < 5 || SETTLE_SECONDS > 120 )); then
  echo "SIMULATOR_SETTLE_SECONDS must be an integer from 5 to 120." >&2
  exit 2
fi
SCREENSHOT_PATH="${SIMULATOR_SCREENSHOT_PATH:-/tmp/marshgo-ios-simulator.png}"
npm ci --prefix web
CAPACITOR_BUILD=true VITE_API_BASE_URL="$VITE_API_BASE_URL" npm run site:build
npx cap sync ios
xcrun simctl boot "$SIMULATOR_UDID" 2>/dev/null || true
xcrun simctl bootstatus "$SIMULATOR_UDID" -b
xcodebuild -quiet -project ios/App/App.xcodeproj -scheme App -configuration Debug -sdk iphonesimulator \
  -destination "platform=iOS Simulator,id=$SIMULATOR_UDID" -derivedDataPath ios/build CODE_SIGNING_ALLOWED=NO build
xcrun simctl install "$SIMULATOR_UDID" ios/build/Build/Products/Debug-iphonesimulator/App.app
xcrun simctl launch "$SIMULATOR_UDID" ua.marshgo.app
sleep "$SETTLE_SECONDS"
xcrun simctl io "$SIMULATOR_UDID" screenshot "$SCREENSHOT_PATH"
echo "Simulator screenshot saved to $SCREENSHOT_PATH"
