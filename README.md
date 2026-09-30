# MARSHGO iOS

Native Capacitor iOS wrapper for the shared MARSHGO Site/PWA. The React UI is built from [`MarshGO-Site`](https://github.com/dima1203oleg/MarshGO-Site), avoiding a second independently edited UI. Bundle ID: `ua.marshgo.app`.

## Local simulator build

Requirements: macOS, Xcode, iOS Simulator, Node 24.21.0, and a reachable MARSHGO API.

```sh
npm ci
npm run site:checkout
npm ci --prefix web
SIMULATOR_UDID=<device-udid> VITE_API_BASE_URL=http://localhost:3002 npm run build:simulator
```

The included iOS GitHub Action builds the site, syncs Capacitor and compiles the iOS Simulator target. It does not sign an App Store archive or perform a public deployment.

The iOS wrapper pulls the current default branch of `MarshGO-Site` during CI/local setup. A simulator build verifies compilation and first-screen rendering only; authenticated booking, GPS permission, and map-provider behavior require a configured reachable API and separate interactive/device acceptance.

## Status and limits

The current client is a WKWebView wrapper around the PWA. Foreground GPS is supported by the web experience; guaranteed background GPS, physical-device permission verification, camera/QR scanner, push notifications, App Store signing, and release metadata are not complete. Map display and navigation need configured production routing and contracted/self-hosted map tiles. Do not ship with a blank or local-only `VITE_API_BASE_URL`.

Latest local visual check: installed and launched on iPhone 15 Pro Max and iPhone 16 Pro Max simulators with the shared site bundle. The welcome screen and safe-area layout render on both; a production sign-in/booking journey was not exercised by this render check.
