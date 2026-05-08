# CodexBar agent-handoff README

This checkout is not being maintained as a polished upstream-style product branch. This is a personal-use fork/branch whose only goal is: keep CodexBar pleasant to look at for the local user, especially by Chinese-localizing the main menu/home UI, while staying easy to rebase on top of upstream `steipete/codexbar`.

## Operating intent

- User does not need a general-purpose i18n architecture.
- User does not need App Store / distribution quality localization.
- User does need a version that feels good locally and can be refreshed against upstream often.
- Therefore: prefer a thin, centralized translation shim plus small call-site edits over broad architectural churn.
- Do not sprawl localization edits across the repo if a call can be routed through the translation shim.
- Preserve upstream structure whenever possible; minimize conflict surface.

## Current git topology

- Local upstream remote: `origin -> https://github.com/steipete/codexbar`
- User fork remote: `fork -> https://github.com/imeelinew/CodexBarCN.git` (private; repo name kept for now even though local app was un-renamed)
- Working branch for localized version: `codex/zh-cn-ui-prototype`
- Current fork push target: `fork/codex/zh-cn-ui-prototype`

Typical future sync flow:

```bash
git checkout main
git fetch origin
git rebase origin/main
git checkout codex/zh-cn-ui-prototype
git rebase main
git push --force-with-lease fork codex/zh-cn-ui-prototype
```

If upstream touches the same UI text areas, resolve conflicts by preserving the thin translation-layer pattern, not by reintroducing scattered hard-coded Chinese strings.

## What was changed for the personal Chinese version

Primary goal: Chinese-localize the visible menu/home layer shown when clicking the menu bar app.

Covered areas:

- Overview switcher label
- Main menu card labels like `Session`, `Weekly`, `Designs`, `Daily Routines`
- Percent/status wording like `used`, `left`, `Updated`, `Resets`, countdown/reset phrasing
- Pace/risk phrasing
- Bottom menu items like `Refresh`, `Settings...`, `About CodexBar`, `Quit`
- Simple plan-name display normalization
- Minimal menu/account label localization like `Account`, `Plan`, `Quota`

Intentionally not treated as a full product-localization pass:

- Deep settings pages
- All provider-specific explanatory copy
- All diagnostics/errors
- All docs/site/release copy
- Full runtime locale switching

## Localization design rule used here

Centralize personal-translation policy in one file:

- [Sources/CodexBarCore/PrototypeChineseLocalization.swift](/Users/eli/Dev/codexbar/Sources/CodexBarCore/PrototypeChineseLocalization.swift:1)

This file is the first place to edit when:

- user wants wording changes
- upstream introduces new nearby labels
- merge conflicts need simplification

Current call sites that intentionally consume this layer:

- [Sources/CodexBarCore/UsageFormatter.swift](/Users/eli/Dev/codexbar/Sources/CodexBarCore/UsageFormatter.swift:1)
- [Sources/CodexBar/UsagePaceText.swift](/Users/eli/Dev/codexbar/Sources/CodexBar/UsagePaceText.swift:1)
- [Sources/CodexBar/MenuDescriptor.swift](/Users/eli/Dev/codexbar/Sources/CodexBar/MenuDescriptor.swift:1)
- [Sources/CodexBar/MenuCardView.swift](/Users/eli/Dev/codexbar/Sources/CodexBar/MenuCardView.swift:1)
- [Sources/CodexBar/StatusItemController+SwitcherViews.swift](/Users/eli/Dev/codexbar/Sources/CodexBar/StatusItemController+SwitcherViews.swift:1)
- [Sources/CodexBarCore/Providers/Codex/CodexPlanFormatting.swift](/Users/eli/Dev/codexbar/Sources/CodexBarCore/Providers/Codex/CodexPlanFormatting.swift:1)

Supporting compatibility edit:

- [Sources/CodexBar/MenuHighlightStyle.swift](/Users/eli/Dev/codexbar/Sources/CodexBar/MenuHighlightStyle.swift:1)

Reason for that compatibility edit:

- repo used SwiftUI `@Entry` macro for `EnvironmentValues`
- this machine/toolchain initially failed to build because `SwiftUIMacros.EntryMacro` plugin was unavailable
- file was rewritten to an old-style `EnvironmentKey` implementation
- keep that unless upstream/toolchain compatibility is clearly restored

## Build/runtime facts on this machine

This machine has:

- `/Applications/Xcode.app`
- `xcode-select -p` may still point to `/Library/Developer/CommandLineTools`

Important consequence:

- plain `swift build` and plain script runs may fail or behave inconsistently
- packaging needs full Xcode developer dir

Preferred build/run invocation on this machine:

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer ./Scripts/compile_and_run.sh --debug-lldb
```

### CLI Tarballs (macOS/Linux)
Homebrew formula (Linux today):
```bash
brew install steipete/tap/codexbar
```
Or download release tarballs from GitHub Releases:
- macOS: `CodexBarCLI-v<tag>-macos-arm64.tar.gz`, `CodexBarCLI-v<tag>-macos-x86_64.tar.gz`
- Linux: `CodexBarCLI-v<tag>-linux-aarch64.tar.gz`, `CodexBarCLI-v<tag>-linux-x86_64.tar.gz`

### First run
- Open Settings → Providers and enable what you use.
- Install/sign in to the provider sources you rely on: CLIs, browser sessions, OAuth/device flow, API keys, local app files, or provider apps depending on the provider.
- Optional: Settings → Providers → Codex → OpenAI cookies (Automatic or Manual) to add dashboard extras.

## Providers

- [Codex](docs/codex.md) — OAuth API or local Codex CLI, plus optional OpenAI web dashboard extras.
- [Claude](docs/claude.md) — OAuth API, browser cookies, or CLI PTY fallback; session and weekly usage where available.
- [Cursor](docs/cursor.md) — Browser session cookies for plan + usage + billing resets.
- [OpenCode](docs/opencode.md) — Browser cookies for workspace subscription usage.
- [OpenCode Go](docs/opencode.md) — Browser cookies for Go usage windows.
- [Alibaba Coding Plan](docs/alibaba-coding-plan.md) — Web cookies or API key for coding-plan quotas.
- [Gemini](docs/gemini.md) — OAuth-backed quota API using Gemini CLI credentials (no browser cookies).
- [Antigravity](docs/antigravity.md) — Local language server probe (experimental); no external auth.
- [Droid](docs/factory.md) — Browser cookies + WorkOS token flows for Factory usage + billing.
- [Copilot](docs/copilot.md) — GitHub device flow + Copilot internal usage API.
- [z.ai](docs/zai.md) — API token for quota + MCP windows.
- [MiniMax](docs/minimax.md) — API token, cookie header, or browser cookies for coding-plan usage.
- [Kimi](docs/kimi.md) — Auth token (JWT from `kimi-auth` cookie) for weekly quota + 5‑hour rate limit.
- [Kimi K2](docs/kimi-k2.md) — API key for credit-based usage totals.
- [Kilo](docs/kilo.md) — API token with CLI-auth fallback for Kilo Pass usage.
- [Kiro](docs/kiro.md) — CLI-based usage; monthly credits + bonus credits.
- [Vertex AI](docs/vertexai.md) — Google Cloud gcloud OAuth with token cost tracking from local Claude logs.
- [Augment](docs/augment.md) — Augment CLI or browser cookies for credits tracking and usage monitoring.
- [Amp](docs/amp.md) — Browser cookie-based authentication with Amp Free usage tracking.
- [Ollama](docs/ollama.md) — Browser cookies for Ollama Cloud usage windows.
- [JetBrains AI](docs/jetbrains.md) — Local XML-based quota from JetBrains IDE configuration; monthly credits tracking.
- [Warp](docs/warp.md) — API token for GraphQL request limits and monthly credits.
- [OpenRouter](docs/openrouter.md) — API token for credit-based usage tracking across multiple AI providers.
- Perplexity — Account usage credits from Perplexity usage data.
- [Abacus AI](docs/abacus.md) — Browser cookie auth for ChatLLM/RouteLLM compute credit tracking.
- Mistral — Browser cookies for monthly spend tracking.
- [DeepSeek](docs/deepseek.md) — API key for credit balance tracking (paid vs. granted breakdown).
- [Codebuff](docs/codebuff.md) — API token (or `~/.config/manicode/credentials.json`) for credit balance + weekly rate limit.
- Open to new providers: [provider authoring guide](docs/provider.md).

## Icon & Screenshot
The menu bar icon is a tiny usage meter. Bar meaning is provider-specific, and errors/stale data can dim the icon or
show an incident indicator.

## Features
- Multi-provider menu bar with per-provider toggles (Settings → Providers).
- Provider-specific usage meters with reset countdowns.
- Optional Codex web dashboard enrichments (code review remaining, usage breakdown, credits history).
- Local cost-usage scan for Codex + Claude (last 30 days).
- Provider status polling with incident badges in the menu and icon overlay.
- Merge Icons mode to combine providers into one status item + switcher.
- Display controls for provider icons, labels, bars, reset-time style, and highest-usage auto-selection.
- Refresh cadence presets (manual, 1m, 2m, 5m, 15m).
- Bundled CLI (`codexbar`) for scripts and CI (including `codexbar cost --provider codex`, `claude`, or `both` for local cost usage); macOS and Linux CLI builds available.
- WidgetKit widgets for supported providers.
- Optional session quota notifications and weekly-reset confetti.
- Privacy-first: on-device parsing by default; browser cookies are opt-in and reused (no passwords stored).

## Privacy note
Wondering if CodexBar scans your disk? It doesn’t crawl your filesystem; it reads a small set of known locations (browser cookies/local storage, provider config files, local JSONL logs) when the related features are enabled. Provider tokens and token-account settings live in `~/.codexbar/config.json` with restrictive file permissions. See the discussion and audit notes in [issue #12](https://github.com/steipete/CodexBar/issues/12).

## macOS permissions (why they’re needed)
- **Full Disk Access (optional)**: only required to read Safari cookies/local storage for web-based providers. If you don’t grant it, use another supported browser, manual cookies/API keys, OAuth, or CLI/local sources where that provider supports them.
- **Keychain access (prompted by macOS)**:
  - Chromium cookie import needs the browser “Safe Storage” key to decrypt cookies.
  - Claude OAuth bootstrap may read the Claude CLI Keychain item when CodexBar has no usable cached credentials.
  - CodexBar may use Keychain for browser cookie decryption, cached cookie headers, and OAuth/device-flow credentials where those sources require it.
  - **How do I prevent those keychain alerts?**
    - Open **Keychain Access.app** → login keychain → search the prompted item (for Claude OAuth, usually “Claude Code-credentials”).
    - Open the item → **Access Control** → add `CodexBar.app` under “Always allow access by these applications”.
    - Prefer adding just CodexBar (avoid “Allow all applications” unless you want it wide open).
    - Relaunch CodexBar after saving.
    - Reference screenshot: ![Keychain access control](docs/keychain-allow.png)
  - **How to do the same for the browser?**
    - Find the browser’s “Safe Storage” key (e.g., “Chrome Safe Storage”, “Brave Safe Storage”, “Microsoft Edge Safe Storage”).
    - Open the item → **Access Control** → add `CodexBar.app` under “Always allow access by these applications”.
    - This removes the prompt when CodexBar decrypts cookies for that browser.
- **Files & Folders prompts (folder/volume access)**: CodexBar launches provider CLIs and local probes for some providers. If those helpers read a project directory or external drive, macOS may ask CodexBar for that folder/volume (e.g., Desktop or an external volume). This is driven by the helper’s working directory, not background disk scanning.
- **What we do not request in the background**: no Screen Recording or Accessibility permissions; user-triggered helper actions may ask macOS for Automation permission to open Terminal. No passwords are stored (browser cookies are reused when you opt in).

## Docs
- Providers overview: [docs/providers.md](docs/providers.md)
- Provider authoring: [docs/provider.md](docs/provider.md)
- Issue labeling guide: [docs/ISSUE_LABELING.md](docs/ISSUE_LABELING.md)
- UI & icon notes: [docs/ui.md](docs/ui.md)
- CLI reference: [docs/cli.md](docs/cli.md)
- Configuration: [docs/configuration.md](docs/configuration.md)
- Widgets: [docs/widgets.md](docs/widgets.md)
- Architecture: [docs/architecture.md](docs/architecture.md)
- Refresh loop: [docs/refresh-loop.md](docs/refresh-loop.md)
- Status polling: [docs/status.md](docs/status.md)
- Sparkle updates: [docs/sparkle.md](docs/sparkle.md)
- Packaging: [docs/packaging.md](docs/packaging.md)
- Development: [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)
- Release checklist: [docs/RELEASING.md](docs/RELEASING.md)
- Changelog: [CHANGELOG.md](CHANGELOG.md)

## Getting started (dev)
- Clone the repo and open it in Xcode or run the scripts directly.
- Launch once, then toggle providers in Settings → Providers.
- Install/sign in to provider sources you rely on (CLIs, browser cookies, OAuth/device flow, API keys, or local app/config files).
- Optional: set OpenAI cookies (Automatic or Manual) for Codex dashboard extras.

## Build from source
Requires macOS 14+ and Swift 6.2+.

```bash
./Scripts/package_app.sh        # builds CodexBar.app in-place
CODEXBAR_SIGNING=adhoc ./Scripts/package_app.sh  # ad-hoc signing (no Apple Developer account)
open CodexBar.app
```

If you only need to rebuild the app bundle:

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer ./Scripts/package_app.sh debug
```

Why `--debug-lldb`:

- creates `com.steipete.codexbar.debug`
- uses debug app-group/container
- avoids directly colliding with official release app state

## Official app vs local test app isolation

The user has removed `/Applications/CodexBar.app` from this machine to avoid confusion with the local build, so right now there is only one CodexBar in play:

- `/Users/eli/Dev/codexbar/CodexBar.app`
- debug bundle id when built with debug packaging: `com.steipete.codexbar.debug`

The bundle id is **deliberately still `.debug`-suffixed** even though there is no official app to collide with. Reasoning: if the user reinstalls `/Applications/CodexBar.app` later, the local build will keep its own state under separate app group / preferences domains:

- would-be official group: `~/Library/Group Containers/Y5PE65HELJ.com.steipete.codexbar`
- debug group: `~/Library/Group Containers/Y5PE65HELJ.com.steipete.codexbar.debug`
- would-be official plist: `~/Library/Preferences/com.steipete.codexbar.plist`
- debug plist: `~/Library/Preferences/com.steipete.codexbar.debug.plist`

Do not collapse the `.debug` suffix into the bare bundle id.

## Config/state cloning rule used for local testing

User wanted local test build to feel like official app immediately. The practical clone step used:

```bash
cp ~/Library/Preferences/com.steipete.codexbar.plist ~/Library/Preferences/com.steipete.codexbar.debug.plist
cp ~/Library/Group\ Containers/Y5PE65HELJ.com.steipete.codexbar/Library/Preferences/Y5PE65HELJ.com.steipete.codexbar.plist \
   ~/Library/Group\ Containers/Y5PE65HELJ.com.steipete.codexbar.debug/Library/Preferences/Y5PE65HELJ.com.steipete.codexbar.debug.plist
cp ~/Library/Group\ Containers/Y5PE65HELJ.com.steipete.codexbar/widget-snapshot.json \
   ~/Library/Group\ Containers/Y5PE65HELJ.com.steipete.codexbar.debug/widget-snapshot.json
```

Notes:

- This clones visible prefs/snapshot, not every possible secret/cache.
- Some config also lives in `~/.codexbar/config.json`; if future behavior seems inconsistent between official/debug, inspect that file too.
- Prefer cloning official -> debug, not the reverse.

## Current known build blockers/workarounds

### 1. KeyboardShortcuts preview macro problem in `.build/checkouts`

Observed issue:

- dependency checkout `KeyboardShortcuts` contained `#Preview` blocks
- local toolchain lacked the macro plugin for those previews
- build failed before app packaging

Local workaround that was used:

- edit `.build/checkouts/KeyboardShortcuts/Sources/KeyboardShortcuts/Recorder.swift`
- remove the trailing `#Preview` blocks

Important:

- this workaround is outside tracked repo files
- it will be lost if dependency checkout is refreshed
- if build fails again in the same spot, repeat the workaround

### 2. SwiftUI `@Entry` macro problem in repo source

Observed issue:

- `Sources/CodexBar/MenuHighlightStyle.swift` used `@Entry`
- current environment failed with missing `SwiftUIMacros.EntryMacro`

Tracked workaround:

- replace macro-based environment extension with explicit `EnvironmentKey`
- this change is committed/tracked in this branch

### 3. Sparkle is intentionally disabled for local self-use builds

Observed issue:

- renamed local packaged app could end up failing at runtime while loading `Sparkle.framework`
- for this user, local self-use stability matters more than embedded auto-update support

Tracked workaround:

- `Package.swift` now treats Sparkle as opt-in for local builds
- default local build path does **not** link Sparkle and does **not** define `ENABLE_SPARKLE`
- updater UI falls back to the existing disabled-updater path

If a future agent explicitly wants Sparkle back for a test:

```bash
CODEXBAR_ENABLE_SPARKLE=1 DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer ./Scripts/compile_and_run.sh --debug-lldb
```

Default assumption for this branch:

- leave Sparkle disabled unless the user explicitly asks to re-enable it

## Lint/test/build expectations

Repo guidance said after code/docs edits:

- run `pnpm check`
- run `./Scripts/compile_and_run.sh`

Actual machine reality:

- `pnpm check` can partially succeed
- SwiftFormat passes
- SwiftLint may crash because `SourceKitten/sourcekitd` environment on this machine is unstable
- treat `swiftlint` crash as environment issue unless the output points at actual source violations

Build verification hierarchy on this machine:

1. `pnpm check`
2. if SwiftLint dies in `sourcekitd`, note it and continue
3. `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer ./Scripts/compile_and_run.sh --debug-lldb`
4. verify local debug app process is running from repo path, not `/Applications`

Runtime verification command:

```bash
ps -axo pid,args | rg '(/Applications/CodexBar.app|/Users/eli/Dev/codexbar/CodexBar.app)/Contents/MacOS/CodexBar'
```

Desired post-test state for this user:

- official `/Applications/CodexBar.app` not running
- local repo debug app running

## Editing policy for future agents

- Do not broaden this branch into a full localization framework unless user explicitly asks.
- Prefer editing translation behavior in `PrototypeChineseLocalization.swift`.
- If upstream introduces a new label, route it through the shim if feasible.
- Avoid editing provider/business logic just to localize copy.
- Keep changes small, local, and rebase-friendly.
- If a string can stay upstream and only be post-processed centrally, prefer that.
- If a call site must be touched, touch the smallest surface area possible.

## High-signal file map

- Personal localization shim:
  [Sources/CodexBarCore/PrototypeChineseLocalization.swift](/Users/eli/Dev/codexbar/Sources/CodexBarCore/PrototypeChineseLocalization.swift:1)
- Core formatted text:
  [Sources/CodexBarCore/UsageFormatter.swift](/Users/eli/Dev/codexbar/Sources/CodexBarCore/UsageFormatter.swift:1)
- Pace wording:
  [Sources/CodexBar/UsagePaceText.swift](/Users/eli/Dev/codexbar/Sources/CodexBar/UsagePaceText.swift:1)
- Menu descriptor text assembly:
  [Sources/CodexBar/MenuDescriptor.swift](/Users/eli/Dev/codexbar/Sources/CodexBar/MenuDescriptor.swift:1)
- Main menu card text rendering:
  [Sources/CodexBar/MenuCardView.swift](/Users/eli/Dev/codexbar/Sources/CodexBar/MenuCardView.swift:1)
- Overview tab title:
  [Sources/CodexBar/StatusItemController+SwitcherViews.swift](/Users/eli/Dev/codexbar/Sources/CodexBar/StatusItemController+SwitcherViews.swift:1)
- Menu environment compatibility workaround:
  [Sources/CodexBar/MenuHighlightStyle.swift](/Users/eli/Dev/codexbar/Sources/CodexBar/MenuHighlightStyle.swift:1)

## Current branch purpose summary in one line

Upstream CodexBar + local-user-focused Chinese main-menu localization + debug-build isolation from official app + rebase-friendly thin translation layer + fork push target under `imeelinew/CodexBarCN`.
