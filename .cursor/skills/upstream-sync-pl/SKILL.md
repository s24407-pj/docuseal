---
name: upstream-sync-pl
description: >-
  Resolves DocuSeal upstream tag syncs into the Polish pl fork, fixes
  upstream-merge PR conflicts, aligns en/pl i18n keys, and merges into pl. Use
  when syncing upstream tags, resolving upstream-merge/* conflicts, adding
  missing Polish translations, or finishing a manual sync for this Polish fork.
---

# Upstream sync (Polish fork)

## When to use

Open `upstream-merge/<tag>` PR toward `pl`, especially when the sync workflow left:

- an empty commit titled `conflicts — manual resolve required`, or
- a PR body warning that **brakuje polskich tłumaczeń** (missing en/pl i18n keys).

Automation lives in [`.github/workflows/sync-upstream.yml`](../../../.github/workflows/sync-upstream.yml).

## Sync workflow behavior

| Outcome | PR opened? | Auto-merge? |
|---------|------------|-------------|
| Clean merge + en/pl parity OK | Yes | Yes |
| Clean merge + missing `pl` keys | Yes (lists missing keys) | No — add translations first |
| Merge conflicts | Yes (empty commit, no markers) | No — resolve conflicts first |

Missing translations do **not** fail the workflow; they block auto-merge only.

## Workflow

1. **Identify the tag and branch**
   - Open PR head `upstream-merge/<tag>` → base `pl`.
   - Empty “manual resolve” commit means the merge was aborted; re-merge the tag locally.

2. **Re-merge the upstream tag**
   ```bash
   git fetch upstream --tags
   git checkout -B upstream-merge/<tag> pl
   git merge --no-ff -m "chore: sync upstream <tag>" refs/tags/<tag>
   ```

3. **Resolve `config/locales/i18n.yml`**
   - Take upstream for `en` and all non-`pl` locales.
   - Keep this fork’s **full** `pl:` block (upstream’s `pl:` is a short partial locale — never replace the fork block with it).
   - Add Polish translations for every new `en` leaf key; place them next to the same neighbors as in `en`.
   - Prefer existing Polish wording/quoting from `HEAD` when both sides edit the same key.
   - Remove all conflict markers: `git grep -nE '^(<<<<<<<|>>>>>>>)'`

4. **Preserve fork CI filters**
   - If [`.github/workflows/ci.yml`](../../../.github/workflows/ci.yml) merges, keep `on.push.branches` for `pl`, `upstream-mirror`, and `upstream-merge/**`, while accepting upstream job/runtime changes.

5. **Verify en/pl parity (required before merge)**
   Reuse the checker from `sync-upstream.yml` (flatten leaf keys under `en` and `pl` in `i18n.yml`; fail on any set difference).
   Also confirm `en`/`pl` object key sets match in:
   - `app/javascript/submission_form/i18n.js`
   - `app/javascript/template_builder/i18n.js`

   The scheduled sync opens a PR even when parity fails; fix keys on the `upstream-merge/<tag>` branch, push, then merge manually.

6. **Finish the PR**
   ```bash
   git add -A && git commit   # if resolution needed beyond the merge commit
   git push origin upstream-merge/<tag> --force-with-lease
   gh pr merge <number> --merge
   ```
   Update the PR body to drop the “manual resolve” or “brakuje tłumaczeń” warning once conflicts and locale parity are resolved.

## Locale rules (summary)

| Area | Rule |
|------|------|
| `en` + other upstream locales | Prefer upstream |
| Full fork `pl:` | Keep; extend with new keys |
| New keys | Polish translation + en/pl leaf count equal |
| JS i18n | Same key sets for `en` and `pl` |

## Commit message style

- Merge: `chore: sync upstream <tag>`
- Follow-up locale fix if separate: `fix: resolve locale conflicts and sync Polish keys`
