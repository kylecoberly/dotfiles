# tmux configuration modernization

## Goal

Strip dead code and obsolete settings from a long-running oh-my-tmux-based
config, fix a dual-theme conflict, and add three modern-tmux workflow features
(popup session switcher, popup scratch terminal, vimium-style copy hints).

## Constraints

- Stay on the `gpakosz/.tmux` (oh-my-tmux) framework. Do not roll a bare config.
- Preserve the SSH-reconnect-on-new-window behavior (main reason to keep the framework).
- Preserve existing muscle memory: `C-space` prefix, `|`/`-` splits, mouse on.
- Keep Tokyo Night visual theme via `tmux-nova`.

## Current state

- `tmux/tmux.conf` — 93KB upstream oh-my-tmux, untouched (correct).
- `tmux/tmux.conf.local` — 552 lines. ~400 are copy-pasted oh-my-tmux defaults
  the user hasn't changed; they are no-ops but add maintenance surface area.
- Two theme systems run concurrently: oh-my-tmux's built-in theme
  (`tmux_conf_theme=enabled`) and `tmux-nova`. Nova renders because plugins
  load last, but the framework's theme variables are still computed.
- Plugins: `tmux-sensible`, `tmux-resurrect`, `tmux-continuum`, `tmux.nvim`,
  `tmux-yank`, `tmux-open`, `tmux-autoreload`, `tmux-nova`, `tmux-cpu`,
  `tmux-keyboard-layout`.
- Manual `C-hjkl` pane-nav bindings shadow `tmux.nvim`'s seamless navigation.

## Design

### Framework

Stay on oh-my-tmux. Leave `tmux.conf` alone. Rewrite `tmux.conf.local` from
scratch (~120 lines).

### `tmux.conf.local` structure

Sections, in order:

1. oh-my-tmux feature flags (SSH reconnect, retain-current-path, copy-to-OS-clipboard)
2. Theme disable (`tmux_conf_theme=disabled`)
3. Core overrides (prefix, mouse, history, escape-time, copy mode)
4. Splits (`|`, `-`)
5. Reload binding (`prefix + r`)
6. Plugin list (TPM)
7. Plugin settings (resurrect/continuum, nova theme colors, sessionx, floax, thumbs)
8. Nova status bar wiring (segments, colors)

### Plugin changes

Remove:

- `tmux-plugins/tmux-sensible` — oh-my-tmux already covers these defaults.
- `tmux-plugins/tmux-cpu` — user confirmed not used.
- `ofirgall/tmux-keyboard-layout` — user confirmed not used.

Add:

- `omerxx/tmux-sessionx` — fzf popup session/window switcher.
  - Binding: `prefix + o` (plugin default; avoids colliding with native `prefix + s`).
- `omerxx/tmux-floax` — floating scratch terminal with persistent hidden session.
  - Binding: `prefix + p` ("popup"; does not collide with oh-my-tmux defaults).
- `fcsonline/tmux-thumbs` — vimium-style hint copying.
  - Binding: `prefix + Space`.
  - Rust binary dependency; plugin compiles on first load.

Keep: `tmux-resurrect`, `tmux-continuum`, `tmux.nvim`, `tmux-yank`, `tmux-open`,
`tmux-autoreload`, `tmux-nova`.

### Keybindings removed from `.local`

These are redundant with `tmux.nvim`:

- `bind -r C-h run "tmux select-pane -L"`
- `bind -r C-j run "tmux select-pane -D"`
- `bind -r C-k run "tmux select-pane -U"`
- `bind -r C-l run "tmux select-pane -R"`
- `bind -r C-\\ run "tmux select-pane -l"`

### Keybindings added

- `bind r source-file ~/.config/tmux/tmux.conf \; display "reloaded"` — faster
  than waiting for `tmux-autoreload` and gives visual feedback.
- Copy mode bindings for vi:
  - `setw -g mode-keys vi`
  - `bind -T copy-mode-vi v send-keys -X begin-selection`
  - `bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"` (via tmux-yank)

### Status bar (nova)

- Left segment: `session` (Tokyo Night green-on-grey, already configured).
- Right segments, in order:
  - `prefix` (already configured)
  - `git` (new) — via shell script
  - `host` (new) — via shell script, empty when not ssh'd

### New scripts

`tmux/scripts/git-branch.sh` — reads `$1` (pane current path), outputs
` {branch-name}` (leading nerd-fonts git glyph U+E0A0) or empty string
when not inside a git repo. Silences errors from `git rev-parse`.

`tmux/scripts/ssh-host.sh` — outputs `$(hostname -s)` if `$SSH_TTY` or
`$SSH_CONNECTION` is set, else empty.

Both scripts made executable via `chmod +x`.

### File layout

```
tmux/
├── tmux.conf              # upstream, untouched
├── tmux.conf.local        # rewritten, ~120 lines
├── install.sh             # unchanged
├── scripts/               # new
│   ├── git-branch.sh
│   └── ssh-host.sh
├── plugins/               # gitignored, TPM-managed
└── .gitignore             # unchanged
```

## Non-goals

- No change to `install.sh` behavior (symlink to `~/.config/tmux`).
- No change to plugin install mechanism (TPM via oh-my-tmux).
- No change to the nixos/ sibling tmux config (separate concern).
- No plugin added just because it's popular (e.g., `tmux-which-key`,
  `tmux-battery`). Only the three the user confirmed.

## Testing

Manual verification checklist:

- [ ] `tmux kill-server && tmux` starts clean with no errors.
- [ ] `prefix + I` installs all plugins.
- [ ] Status bar renders: session on left; prefix indicator appears on
      `C-space`; git branch shows in a git repo pane; host only appears
      under ssh.
- [ ] `prefix + o` opens sessionx popup.
- [ ] `prefix + p` opens floax scratch terminal.
- [ ] `prefix + Space` triggers thumbs hints in copy mode.
- [ ] `C-h/j/k/l` from an nvim pane moves between nvim splits, then crosses
      into tmux panes at nvim's edge.
- [ ] New window from an ssh pane re-establishes the ssh connection.
- [ ] `prefix + r` reloads and shows confirmation.
- [ ] Copy mode uses vi bindings (`v` selects, `y` yanks to clipboard).

## Risk / rollback

Single-file change plus two new scripts. Rollback is `git checkout tmux/`.
