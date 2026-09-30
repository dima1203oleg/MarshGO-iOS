# MARSHGO iOS app

MARSHGO has a Capacitor iOS target that packages the existing React app in a native WKWebView. It uses bundle ID `ua.marshgo.app`, iOS 15 or later, the MARSHGO app icon, and portrait layout. The mobile-first home/search/trips/chat/profile shell follows the supplied reference. The welcome screen uses a bundled Carpathian road image, a transparent status bar with light icons, and five-control bottom navigation. Vehicle CRUD, offer booking, passenger demand, driver publishing and proposal negotiation use the current API. Driver foreground navigation now requests a real GPS fix and server-computed road route, resumes an active session, streams validated foreground fixes, and deletes precise position data when ended. Passive matching, turn instructions, rerouting, tile-provider setup, background GPS, and physical-device permission verification remain incomplete.

## Build and run on a simulator

Requirements: macOS, Xcode, Bun (the repository package manager), and an available iOS Simulator. The API must use a local development OTP adapter; the application must not use live SMS credentials during simulator testing.

```sh
docker compose up -d db redis
DATABASE_URL=postgres://marshgo:local_only_change_me@127.0.0.1:5434/marshgo bun run db:migrate
DATABASE_URL=postgres://marshgo:local_only_change_me@127.0.0.1:5434/marshgo \
NODE_ENV=development AUTH_DEV_OTP=true API_HOST=0.0.0.0 \
CORS_ORIGINS=capacitor://localhost,http://localhost:3000 \
SESSION_SECRET=local-simulator-only-secret bun run api
```

In another terminal, provide a simulator UDID from `xcrun simctl list devices available`:

```sh
SIMULATOR_UDID=<device-udid> bun run ios:simulator
```

The simulator build points at `http://localhost:3002`. The iOS target permits cleartext HTTP only for the `localhost` hostname for local development. Release builds must set `VITE_API_BASE_URL` to the HTTPS API origin; do not ship the simulator endpoint or local development OTP configuration.

The production welcome and authenticated mobile screens are built from the same React/Capacitor app. Site revision `03f3027` was cloned from the published `MarshGO-Site` main, rebuilt into the native shell, compiled with Xcode, and installed/launched on iPhone 15 Pro Max and iPhone 16 Pro Max simulators. Screenshots `/tmp/marshgo-site03f3027-iphone15.png` and `/tmp/marshgo-site03f3027-iphone16.png` show the road background, brand lockup, Ukrainian copy, CTA hierarchy, and safe-area layout on both screen sizes. The first iPhone 16 capture occurred before WebKit finished rendering; after relaunch and a 10-second render wait, the screenshot showed the complete welcome screen. The previous map retry screenshots are `/tmp/marshgo-iphone15-map-retry.png` and `/tmp/marshgo-iphone16-map-retry.png`. A signed-in mobile E2E screenshot at `/tmp/marshgo-home-ukraine-date.png` confirms the reference-style home layout and Ukrainian date text. These runs do not perform OTP entry inside native iOS or authenticated native booking gestures. The latest Pro Max simulator build used `http://localhost:3002` with no API process running, so only first-screen rendering is verified there. The local toolchain was Node 25.4.0 while the project pins Node 24.21.0; the simulator build completed with an engine warning, and CI uses the pinned version.

## Native limitations and release work

* The current app relies on the existing browser session client. Validate refresh-cookie persistence across force-quit/relaunch on physical iOS devices before release.
* `NSLocationWhenInUseUsageDescription` describes foreground route use. Navigation requires `ROUTING_ENGINE_URL`; without it, starting a route returns an unavailable error. `VITE_MAP_TILE_URL` and attribution must point to a contracted or self-hosted tile service before street-map tiles appear.
* Background GPS is not supported or claimed. Push notifications, camera upload, App Store metadata/signing/privacy declarations, and physical-device GPS-permission testing remain separate work.
* No App Store archive, signing profile, public endpoint, production SMS, or external payment was created or used in simulator testing.
* This environment has the CoreSimulator runtime and `simctl` but does not include the graphical `Simulator.app`; `simctl` installed/launched the app and captured its production welcome screen, but interactive field entry and booking gestures could not be automated here.
* Site revision `3f000cd` tracks tile health per visible tile and adds a retry action for a degraded/failed map layer. The iOS Simulator Build workflow checks out the current `MarshGO-Site` main branch and compiles this revision into the native bundle. Street tiles still require an approved provider URL and attribution. E2E verifies a simulated partial tile outage and recovery on both Pro Max viewport sizes; this does not verify an actual contracted provider.
