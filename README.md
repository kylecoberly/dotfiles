# Kyle Coberly's dotfiles

Managed with [chezmoi](https://www.chezmoi.io). The repo is the chezmoi
source dir, kept at `~/dotfiles`.

## Install

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --source ~/dotfiles --apply git@github.com:kylecoberly/dotfiles.git
```

(`chezmoi` itself comes from brew on macOS; the bootstrap line above installs
it anywhere.)

## Layout

- `dot_*`, `dot_config/` — chezmoi source state, applied into `$HOME`
- `run_onchange_*.sh.tmpl` — package installs + service wiring, re-run when
  their content (or embedded hashes) change
- `.chezmoiexternal.toml` — zsh plugins, cloned/refreshed by chezmoi
  (tmux plugins stay TPM-managed; tmux.conf bootstraps tpm itself)
- `machine/` — installer helpers and Brewfile (never applied to `$HOME`)
- `theme/` — Tokyo Night palette source; `./theme/regenerate.sh` then
  `chezmoi apply`
- `tests/` — `tests/run.sh` runs hook tests against a sandbox apply

## Sync model

- Config changes: edit in `~/dotfiles` (or `chezmoi edit`), `chezmoi apply`;
  autoCommit/autoPush handle git.
- Runtime-mutated files (Claude settings, karabiner.json): captured by
  `chezmoi-sync` (launchd/systemd, every 30 min) via `chezmoi re-add`, then
  pull+apply+push. Failures surface as `⚠ sync` in the Claude statusline;
  check `~/.cache/chezmoi-sync/last-error`.
- Claude plans (`ExitPlanMode` hook) and `/save-artifact` write into the
  Obsidian vault at `zz_/plans|artifacts/<account>/<project>/` — Obsidian
  Sync is their transport, not git. The account (`personal`/`work`) is
  detected from the active Claude login at save time.

## History

The pre-chezmoi symlink layout is preserved on the `legacy` branch.
