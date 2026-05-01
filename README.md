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
- User fork remote: `fork -> https://github.com/imeelinew/CodexBar.git`
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

If you only need to rebuild the app bundle:

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer ./Scripts/package_app.sh debug
```

Why `--debug-lldb`:

- creates `com.steipete.codexbar.debug`
- uses debug app-group/container
- avoids directly colliding with official release app state

## Official app vs local test app isolation

Official installed app observed on this machine:

- `/Applications/CodexBar.app`
- bundle id: `com.steipete.codexbar`

Local built test app in this repo:

- `/Users/eli/Dev/codexbar/CodexBar.app`
- debug bundle id when built with debug packaging: `com.steipete.codexbar.debug`

App-group/container separation:

- official group: `~/Library/Group Containers/Y5PE65HELJ.com.steipete.codexbar`
- debug group: `~/Library/Group Containers/Y5PE65HELJ.com.steipete.codexbar.debug`

Preference domain separation:

- official plist: `~/Library/Preferences/com.steipete.codexbar.plist`
- debug plist: `~/Library/Preferences/com.steipete.codexbar.debug.plist`

This separation is desired. Do not collapse it.

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

Upstream CodexBar + local-user-focused Chinese main-menu localization + debug-build isolation from official app + rebase-friendly thin translation layer + fork push target under `imeelinew/CodexBar`.
