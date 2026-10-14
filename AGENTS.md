# MarshGO-iOS

This repository owns the Capacitor/Xcode host, native iOS integrations, permissions, background GPS behavior, push capabilities, simulator and signed release workflows. The canonical Web/PWA screens live in `MarshGO-Site`; do not add a maintained copy of those screens here.

Before editing, inspect `git status`, branch, remotes, and the current PR. Preserve all dirty work. Use a short-lived `feature/*` or `fix/*` branch and PR; do not push to `main`, force-push, or merge outside the review process.

The release workflow must consume the full Site commit SHA recorded in the central `MarshGO/RELEASE_MANIFEST.json` and embed that provenance in the app bundle. Do not use a floating branch or a different Site SHA. `site:checkout` defaults to `main` for development; for a release-pinned local build set `SITE_REF` to the exact manifest SHA. With Node 24.21.0, the checked-out workflow and Xcode toolchain, the repository commands are:

```sh
npm ci
SITE_REF=<full-site-sha> npm run site:checkout
npm ci --prefix web
npm run site:build
npm run sync
npm run build:simulator
```

Run commands only where the matching inputs and Xcode environment exist. Simulator compilation does not prove physical-device GPS, background execution, push delivery, signing, or TestFlight acceptance; report those separately.
