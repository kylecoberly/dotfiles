# Chezmoi Migration & Dotfiles Modernization — Design

**Date:** 2026-07-30
**Status:** Approved

## Goal

Replace the symlink-based `install.sh` dotfiles system with a purist chezmoi
setup that syncs cleanly across the MacBook Air and Serena (Ubuntu Server),
centralizes Claude Code configuration, routes Claude plans and artifacts into
the Obsidian vault per account, and pares out the stale vim-era Linux-desktop
remnants. One-command setup is preserved:
`chezmoi init --apply kylecoberly/dotfiles`.

## Context / problems being solved

- Symlinked configs make edits live locally but nothing automates
  commit/push/pull, so machines drift (repo is dirty right now from
  `/config`-driven `settings.json` mutations).
- The `save-plan` hook writes to `zz_plans/`, but the vault convention moved
  to `zz_/plans/<project>/` — plans never landed in the vault. Claude Code
  also now saves plans natively to `~/.claude/plans/`, creating two competing
  systems.
- Plans/artifacts need to be **per Claude account** (personal + work logins,
  sometimes switched on the same machine).
- `linux/` targets a desktop environment Serena no longer has.

## Decisions (user-confirmed)

- **Keep:** nvim, tmux, theme system, all mac WM configs (aerospace,
  karabiner, sketchybar, peon), Brewfile.
- **Drop:** Linux desktop alacritty integration (pare `linux` packages to
  headless-server essentials), `shared/`/`macos/`/`linux/` directory triad,
  the `install.sh` scripts, stray `tmux-client-*.log`.
- **Approach:** purist chezmoi, clean-slate source tree, same GitHub repo
  (`kylecoberly/dotfiles`). Old `master` preserved as `legacy` branch.
- **Accounts:** one Obsidian vault; hook auto-detects the active login from
  `~/.claude.json`. Mapping: `kyle.coberly@gmail.com` → `personal`,
  `kcoberly@nsls.org` → `work`, unknown → sanitized email.
- **Serena vault:** `/mnt/files/application-data/obsidian/notes` is a real
  synced vault (Obsidian runs in a desktop emulator there); hooks write to it
  directly.

## Repo structure (chezmoi source conventions)

```
├── .chezmoi.toml.tmpl          # autoCommit/autoPush on
├── .chezmoiignore.tmpl         # excludes docs/ & theme/ from $HOME;
│                               # excludes mac-only dirs on linux
├── dot_zshrc.tmpl, dot_gitconfig, dot_tool-versions, …
├── dot_config/
│   ├── nvim/  tmux/  alacritty/  starship.toml   # templated where OS-specific
│   ├── aerospace/  karabiner/  sketchybar/       # mac-only
│   └── mise/
├── dot_claude/                 # settings.json, CLAUDE.md, statusline,
│                               # commands/, hooks/
├── run_onchange_darwin-packages.sh.tmpl   # brew bundle (Brewfile hash-keyed)
├── run_onchange_linux-packages.sh.tmpl    # apt, headless-server list only
├── theme/                      # palette source + regenerator (repo tooling)
└── docs/                       # README, specs
```

OS differences live in templates (`{{ if eq .chezmoi.os "darwin" }}`) for
shared-but-divergent files, and in `.chezmoiignore` for whole mac-only
directories.

## Claude + Obsidian layer

- `dot_claude/` manages `settings.json` (including `enabledPlugins`),
  `CLAUDE.md`, `statusline-command.sh`, `commands/`, `hooks/`.
- **save-plan hook** (PostToolUse on ExitPlanMode):
  1. Vault: `$OBSIDIAN_VAULT` → `/mnt/files/application-data/obsidian/notes`
     → `~/Documents/notes`; silent no-op if absent.
  2. Account: `.oauthAccount.emailAddress` from `~/.claude.json`, mapped to
     `personal`/`work` slug.
  3. Path: `zz_/plans/<account>/<project>/<timestamp>-<slug>.md` with the
     existing frontmatter format. `<project>` = git-repo basename, `home`,
     or cwd basename (unchanged logic).
- **`/load-plan`** updated to the same account-aware path scheme.
- **`/save-artifact <file> [description]`** (new): copies a deliverable to
  `zz_/artifacts/<account>/<project>/`; prepends frontmatter (created, source
  path, project, description) for markdown, verbatim otherwise.
- The vault (Obsidian Sync + Serena's emulator) is the transport for plans
  and artifacts; git is the transport for config.
- peon-ping: only `config.json` managed; binary/pack install stays in the
  package `run_` script.

## Sync automation

- chezmoi `git.autoCommit = true`, `git.autoPush = true`.
- A `sync` script run by launchd (Mac) / systemd timer (Serena) every ~30 min:
  1. `chezmoi re-add` known runtime-mutated files (`~/.claude/settings.json`,
     `~/.claude/CLAUDE.md`, karabiner's `karabiner.json`)
  2. `chezmoi update` (pull + apply)
  3. push
- On pull/push failure: stop and drop a warning file the statusline surfaces.
  Never force.

## Migration plan (old setup works until cutover)

1. Build the new source tree on a `chezmoi` branch, porting file-by-file.
2. Iterate until `chezmoi apply --dry-run` diff shows only intended changes.
3. Mac cutover: remove old symlinks, `chezmoi apply`, smoke-test
   zsh/nvim/tmux/karabiner/aerospace/Claude.
4. Rebranch: old `master` → `legacy`; new tree → `master`; push.
5. Serena: fresh `chezmoi init --apply`; verify server-only package set and
   that the plan hook writes to `/mnt/files/.../zz_/plans/`.

## Testing

- Shell tests (bats-style or plain scripts) for the plan/artifact hooks:
  account detection, path routing, vault fallback.
- `chezmoi doctor`, empty `chezmoi diff`, and a smoke checklist for the rest.

## Error handling

Minimal by design: hooks no-op silently when the vault is missing; the sync
script stops and surfaces on failure rather than forcing.
