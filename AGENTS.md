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

## Handoff across Codex windows and tasks

Codex chats, cloud tasks, local worktrees and feature branches are **not** shared conversation memory. Before assuming work from another window is present, verify the checked-out repository, working tree, current branch and HEAD SHA, upstream/ref, and relevant open PRs. Fetch remote refs when access allows, without overwriting dirty files or automatically merging. An open PR or a successful build does **not** mean its changes are on `main` or deployed. If expected functionality exists only in another branch, name that branch/PR and exact commit; do not silently recreate it or replace a newer implementation with an older one.

For a task spanning Server, Site or iOS, identify the exact source commit of each dependent repository and reconcile it with the canonical release manifest before integrating or building; do not use a floating `main` branch as proof of which version is deployed. Verify actual deployment access and deployed SHA before making production claims. Never modify production, force-push, merge open PRs, or discard another task's work without explicit authorization.

At the end of each task, leave a concise handoff in the PR description when applicable and always in the final report: repository, branch, HEAD commit, PR URL/status, changed files, checks run and skipped, dependent branch/commit SHAs, unresolved blockers, and next action. The next Codex chat must verify these facts from Git rather than assuming it sees the preceding conversation.

Keep verification proportional to risk: run focused checks during development, reserve full suites, complete native/iOS builds and release packaging for meaningful checkpoints, PR gates or changes requiring them. Do not skip required CI or release checks; report omitted validation explicitly. Avoid repeatedly feeding large successful build logs into the model.
