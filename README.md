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

Development CI/local setup may use `MarshGO-Site/main`; local builds can pin an exact Site revision with `SITE_REF=<full-sha> npm run site:checkout`. Version-tagged iOS builds require `MARSHGO_SITE_SHA` and `MARSHGO_SERVER_SHA` full commit SHAs, plus API-contract and migration versions. The workflow embeds `release-manifest.json` containing those exact revisions. A simulator build verifies compilation only; authenticated booking, GPS permission, and map-provider behavior require a configured reachable API and separate interactive/device acceptance.

## Status and limits

The current client is a WKWebView wrapper around the PWA. Foreground GPS is supported by the web experience; guaranteed background GPS, physical-device permission verification, camera/QR scanner, push notifications, App Store signing, and release metadata are not complete. Map display and navigation need configured production routing and contracted/self-hosted map tiles. Do not ship with a blank or local-only `VITE_API_BASE_URL`.

Earlier simulator visual checks covered the welcome screen and safe-area layout on iPhone 15 Pro Max and iPhone 16 Pro Max; they did not exercise production sign-in or booking. Branch CI builds the shared Web release pin `3f2c9be87b3f92f695ba1d7abc4128ab2a1d74d9` (the Site revision behind the running `marshgo/web:RC-2026-11-02-popupdate.2` image); release tags ignore that fallback and require the `MARSHGO_SITE_SHA` / `MARSHGO_SERVER_SHA` / `MARSHGO_API_BASE_URL` repository variables. Simulator CI for this pin is pending, and physical-device acceptance is still open.

## Cross-repository audit

The architecture and migration audit is maintained by the MarshGO documentation owner in the [`codex/marshgo-production` audit index](https://github.com/dima1203oleg/MarshGO/tree/codex/marshgo-production/docs/audit). Simulator success does not imply App Store or production readiness.
