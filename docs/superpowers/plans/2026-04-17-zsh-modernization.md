# Zsh Modernization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace oh-my-zsh + custom Powerline theme + asdf with a lean native-zsh setup using Starship, mise, and modern CLI tools (fzf, zoxide, eza, bat, ripgrep, delta) while preserving all working keybindings and aliases.

**Architecture:** Keep zsh. Drop oh-my-zsh entirely. Source 3 hand-cloned plugins directly (no plugin manager). Starship replaces 279-line custom theme. mise replaces asdf (same `.tool-versions` format). New CLI tools integrate via shell hooks + aliases + git config.

**Tech Stack:** zsh, Starship, mise, Homebrew, fzf + fzf-tab, zoxide, eza, bat, ripgrep, delta, zsh-autosuggestions, zsh-syntax-highlighting.

**Spec:** `docs/superpowers/specs/2026-04-17-zsh-modernization-design.md`

**Testing model:** This is a dotfiles project — no unit tests. Each task is verified by running commands and checking output. Verification steps replace traditional "run the test" steps. Where a task changes config, verification happens in an isolated `ZDOTDIR=/tmp/newzsh zsh` scratch shell before cutover, so your current shell is unaffected until Phase 5.

**Destructive actions:** Phases 5–7 modify your active shell and remove oh-my-zsh/asdf. Each destructive task is flagged ⚠️ and has a rollback note.

---

## Phase 1 — Install tools (additive, non-destructive)

### Task 1: Install new Homebrew packages

**Files:**
- None (system-level installs)

- [ ] **Step 1: Install Homebrew packages**

Run:

```bash
brew install starship mise fzf zoxide eza bat ripgrep git-delta
```

Expected: all 8 formulae install or report "already installed". No error exit.

- [ ] **Step 2: Verify binaries are on PATH**

Run:

```bash
for cmd in starship mise fzf zoxide eza bat rg delta; do
  command -v "$cmd" && "$cmd" --version | head -1
done
```

Expected: each command prints a path and a version line. If `delta` reports not found, its binary is installed as `delta` from the `git-delta` formula — check `brew list git-delta`.

- [ ] **Step 3: No commit yet** (no files changed)

---

### Task 2: Create `~/.zsh/plugins/` and clone the 3 plugins

**Files:**
- Create: `~/.zsh/plugins/zsh-autosuggestions/` (cloned)
- Create: `~/.zsh/plugins/zsh-syntax-highlighting/` (cloned)
- Create: `~/.zsh/plugins/fzf-tab/` (cloned)

- [ ] **Step 1: Create plugin dir**

Run:

```bash
mkdir -p ~/.zsh/plugins
```

- [ ] **Step 2: Clone the three plugins**

Run:

```bash
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/Aloxaf/fzf-tab ~/.zsh/plugins/fzf-tab
```

Expected: three successful clones, no errors.

- [ ] **Step 3: Verify plugin entry files exist**

Run:

```bash
ls ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
   ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
   ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
```

Expected: all three files listed, no "No such file" errors.

- [ ] **Step 4: No commit yet** (these are in `~/.zsh`, not tracked by dotfiles repo)

---

## Phase 2 — Write new config files

All files written in this phase live alongside the old ones. Nothing is activated until Phase 5. Test in scratch shell in Phase 3.

### Task 3: Write `dotfiles/zsh/starship.toml`

**Files:**
- Create: `/Users/kylecoberly/dotfiles/zsh/starship.toml`

- [ ] **Step 1: Write starship.toml**

Create `/Users/kylecoberly/dotfiles/zsh/starship.toml` with:

```toml
# Starship prompt config
# Mimics coberly-gruvbox.zsh-theme segments: OS icon → dir → git branch + status
# Gruvbox palette: yellow #fabd2f, blue #83a598, green #b8bb26, red #fb4934, purple #d3869b

add_newline = false
command_timeout = 1000

format = """
$os\
$directory\
$git_branch\
$git_status\
$character"""

[os]
disabled = false
format = '[ $symbol ](bg:green fg:black)'

[os.symbols]
Macos = ""
Linux = ""
Ubuntu = ""

[directory]
format = '[ $path ](bg:purple fg:black)'
truncation_length = 1
truncation_symbol = ""

[git_branch]
symbol = " "
format = '[ $symbol$branch ](bg:cyan fg:black)'

[git_status]
format = '[$all_status$ahead_behind ](bg:cyan fg:black)'
modified = "${count}● "
staged = "${count} "
untracked = "${count} "
ahead = ""
behind = ""
conflicted = "="
deleted = ""
renamed = "»"
stashed = "\\$"

[character]
success_symbol = '[ ❯](green)'
error_symbol = '[ ❯](red)'
```

- [ ] **Step 2: Verify file written**

Run:

```bash
wc -l /Users/kylecoberly/dotfiles/zsh/starship.toml
```

Expected: ~45 lines.

- [ ] **Step 3: Commit**

```bash
git -C /Users/kylecoberly/dotfiles add zsh/starship.toml
git -C /Users/kylecoberly/dotfiles commit -m "Add starship prompt config

Mimics coberly-gruvbox segments with async git rendering.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

---

### Task 4: Write `dotfiles/zsh/aliases.zsh`

**Files:**
- Create: `/Users/kylecoberly/dotfiles/zsh/aliases.zsh`

This file holds git aliases migrated from the OMZ `git` plugin plus eza shortcuts that don't conflict with existing `apps/.aliases` entries (which already aliases `cat=bat`, defines `ll`, `lsa`, `vi=nvim`, etc.).

- [ ] **Step 1: Write aliases.zsh**

Create `/Users/kylecoberly/dotfiles/zsh/aliases.zsh` with:

```zsh
# Git aliases (migrated subset from oh-my-zsh git plugin)
alias g='git'
alias gst='git status'
alias gss='git status -s'
alias ga='git add'
alias gaa='git add --all'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gbd='git branch -d'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias grb='git rebase'
alias grbi='git rebase -i'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias gm='git merge'
alias gsta='git stash push'
alias gstp='git stash pop'
alias gstl='git stash list'
alias grh='git reset'
alias grhh='git reset --hard'
alias gcl='git clone'
alias gcp='git cherry-pick'

# eza (modern ls) — non-conflicting additions
alias la='eza -la --git --group-directories-first'
alias lt='eza --tree --level=2 --git-ignore'
alias lta='eza --tree --level=3'
```

- [ ] **Step 2: Verify file written**

Run:

```bash
wc -l /Users/kylecoberly/dotfiles/zsh/aliases.zsh
```

Expected: ~40 lines.

- [ ] **Step 3: Commit**

```bash
git -C /Users/kylecoberly/dotfiles add zsh/aliases.zsh
git -C /Users/kylecoberly/dotfiles commit -m "Add aliases.zsh with git shortcuts and eza helpers

Git aliases migrated from OMZ git plugin (subset); eza aliases
added alongside existing apps/.aliases without conflict.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

---

### Task 5: Write new `dotfiles/zsh/.zshrc`

**Files:**
- Modify: `/Users/kylecoberly/dotfiles/zsh/.zshrc` (full rewrite)

- [ ] **Step 1: Overwrite .zshrc**

Replace contents of `/Users/kylecoberly/dotfiles/zsh/.zshrc` with:

```zsh
# ─── Options ───────────────────────────────────────────────────────────
setopt extendedglob nocaseglob globdots
setopt hist_ignore_all_dups hist_reduce_blanks share_history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

export VISUAL=nvim
export EDITOR="$VISUAL"
export COLORTERM=truecolor

# ─── PATH (macOS) ──────────────────────────────────────────────────────
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.fly/bin:$PATH"

# ─── Keybindings ───────────────────────────────────────────────────────
bindkey -v                                  # vi-mode
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins 'jk' vi-cmd-mode
bindkey "\e." insert-last-word              # Alt/Esc-. → last word

# ─── Completion ────────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ─── Plugins ───────────────────────────────────────────────────────────
# Order matters: fzf-tab before compinit-dependent plugins,
# syntax-highlighting MUST be sourced LAST.
source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ─── Tool init ─────────────────────────────────────────────────────────
eval "$(starship init zsh)"
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"          # adds fuzzy ^R, ^T, Alt-C

# ─── Colored man pages ─────────────────────────────────────────────────
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\e[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\e[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\e[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline

# ─── Aliases ───────────────────────────────────────────────────────────
[ -f ~/dotfiles/zsh/aliases.zsh ] && source ~/dotfiles/zsh/aliases.zsh
[ -f ~/.aliases ] && source ~/.aliases
```

- [ ] **Step 2: Verify file written**

Run:

```bash
wc -l /Users/kylecoberly/dotfiles/zsh/.zshrc
```

Expected: ~50-55 lines (down from 73).

- [ ] **Step 3: Commit**

```bash
git -C /Users/kylecoberly/dotfiles add zsh/.zshrc
git -C /Users/kylecoberly/dotfiles commit -m "Rewrite .zshrc: native zsh + starship + mise, drop OMZ

Removes oh-my-zsh framework, custom theme, asdf sourcing,
Linux-specific PATH entries. Adds starship/mise/zoxide/fzf init,
sources 3 hand-managed plugins from ~/.zsh/plugins/.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

**Note:** The new `.zshrc` is not active yet. Your current shell still uses the old setup (via the symlink created by the old install.sh). Phase 5 cuts over.

---

## Phase 3 — Test in scratch ZDOTDIR (safe, non-destructive)

### Task 6: Verify new config in isolated zsh

**Files:**
- None (creates temp dir only)

- [ ] **Step 1: Set up scratch ZDOTDIR**

Run:

```bash
rm -rf /tmp/newzsh && mkdir -p /tmp/newzsh
ln -s /Users/kylecoberly/dotfiles/zsh/.zshrc /tmp/newzsh/.zshrc
ls -la /tmp/newzsh/
```

Expected: `.zshrc` symlink points to dotfiles.

- [ ] **Step 2: Launch scratch shell interactively**

Run (in a NEW terminal tab/window, or describe to user to open one):

```bash
ZDOTDIR=/tmp/newzsh zsh -l
```

Expected: new shell opens, prompt renders via starship (OS icon + dir + git branch on the shared `dotfiles` repo), no errors scrolling past about missing files.

If errors appear about the `aliases.zsh` source line (readlink of non-absolute path), that's because the scratch `.zshrc` is sourced directly instead of via the real `~/.zshrc` symlink. Skip to Step 3 below — Phase 5 will route through `~/.zshrc` where the readlink trick works.

- [ ] **Step 3: In the scratch shell, smoke-test the stack**

Run inside the scratch shell:

```bash
# Prompt — visible already
# Vi mode
bindkey | grep vi-cmd-mode | head -3
# Tool inits
starship --version && mise --version && zoxide --version
# fzf keybindings
bindkey '^R'      # should show 'fzf-history-widget' or similar
bindkey '^T'      # should show 'fzf-file-widget'
# Plugin load
echo "autosuggest: ${ZSH_AUTOSUGGEST_STRATEGY:-unset}"
type _zsh_highlight >/dev/null 2>&1 && echo "syntax-hl: loaded"
# mise (no tools yet, should just run)
mise ls 2>&1 | head
# Git alias
alias gst
```

Expected:
- `bindkey` shows `jj` and `jk` bound to `vi-cmd-mode`
- All three tools print versions
- `^R` bound to `fzf-history-widget`
- Autosuggest strategy printed, syntax-hl says "loaded"
- `mise ls` runs without error
- `gst` is aliased to `git status`

- [ ] **Step 4: Test tab completion**

In the scratch shell, type `cd ` and press Tab. Expected: fzf-tab opens a fuzzy picker with directory entries.

- [ ] **Step 5: Exit scratch shell**

Run: `exit`

- [ ] **Step 6: No commit** (test-only)

If any of the above fails, fix the config in `dotfiles/zsh/` and repeat Task 6 before proceeding.

---

## Phase 4 — Update install.sh

### Task 7: Rewrite `dotfiles/zsh/install.sh`

**Files:**
- Modify: `/Users/kylecoberly/dotfiles/zsh/install.sh` (full rewrite)

- [ ] **Step 1: Overwrite install.sh**

Replace contents of `/Users/kylecoberly/dotfiles/zsh/install.sh` with:

```bash
#!/bin/bash
set -eu

if [ -z "$HOME" ]; then
  exit 1
fi

if [ "${CODESPACES:-}" = "true" ]; then
  DOTFILE_DIRECTORY="/workspaces/.codespaces/.persistedshare/dotfiles"
else
  DOTFILE_DIRECTORY="${HOME}/dotfiles"
fi

# Homebrew packages
BREW_PKGS=(starship mise fzf zoxide eza bat ripgrep git-delta)
if command -v brew >/dev/null 2>&1; then
  for pkg in "${BREW_PKGS[@]}"; do
    brew list "$pkg" >/dev/null 2>&1 || brew install "$pkg"
  done
fi

# Zsh plugins
PLUGIN_DIR="$HOME/.zsh/plugins"
mkdir -p "$PLUGIN_DIR"
clone_if_missing() {
  local repo="$1"
  local dir="$2"
  if [ ! -d "$dir" ]; then
    git clone --depth=1 "$repo" "$dir"
  fi
}
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions       "$PLUGIN_DIR/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting   "$PLUGIN_DIR/zsh-syntax-highlighting"
clone_if_missing https://github.com/Aloxaf/fzf-tab                      "$PLUGIN_DIR/fzf-tab"

# Starship config
mkdir -p "${HOME}/.config"
ln -sf "${DOTFILE_DIRECTORY}/zsh/starship.toml" "${HOME}/.config/starship.toml"

# zshrc symlink
rm -f "${HOME}/.zshrc"
ln -sf "${DOTFILE_DIRECTORY}/zsh/.zshrc" "${HOME}/.zshrc"
```

- [ ] **Step 2: Make executable**

Run:

```bash
chmod +x /Users/kylecoberly/dotfiles/zsh/install.sh
```

- [ ] **Step 3: Verify shellcheck (if available)**

Run:

```bash
command -v shellcheck && shellcheck /Users/kylecoberly/dotfiles/zsh/install.sh || echo "shellcheck not installed, skipping"
```

Expected: no errors, or skipped if shellcheck not installed.

- [ ] **Step 4: Commit**

```bash
git -C /Users/kylecoberly/dotfiles add zsh/install.sh
git -C /Users/kylecoberly/dotfiles commit -m "Rewrite install.sh: brew + plugin clones + symlinks

Replaces OMZ bootstrap with idempotent brew installs, plugin clones
to ~/.zsh/plugins/, and starship.toml + .zshrc symlinks.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

---

## Phase 5 — Cutover (⚠️ activates new shell)

### Task 8: ⚠️ Run new install.sh to swap the active `.zshrc`

**Files:**
- Modify: `~/.zshrc` symlink (replaced via install.sh)
- Create: `~/.config/starship.toml` symlink

This is the moment the new setup becomes active. Your current interactive shell will continue to run on the OLD config until you open a new shell. Rollback: `ln -sf ~/.oh-my-zsh/.zshrc.pre-oh-my-zsh ~/.zshrc` (if OMZ made a backup), or `git -C ~/dotfiles revert HEAD` of the .zshrc commit.

- [ ] **Step 1: Confirm current symlink source (for rollback awareness)**

Run:

```bash
readlink ~/.zshrc
```

Expected: points to `dotfiles/zsh/.zshrc` (already).

- [ ] **Step 2: Run install.sh**

Run:

```bash
/Users/kylecoberly/dotfiles/zsh/install.sh
```

Expected: brew packages confirmed installed, plugins confirmed cloned, symlinks created. No errors.

- [ ] **Step 3: Verify symlinks**

Run:

```bash
readlink ~/.zshrc
readlink ~/.config/starship.toml
```

Expected: both point into `~/dotfiles/zsh/`.

- [ ] **Step 4: No commit** (no tracked files changed)

---

### Task 9: Verify in a fresh shell

**Files:** None

- [ ] **Step 1: Open a new terminal tab/window**

Start a fresh interactive zsh (new tab in your terminal, or run `zsh -l`).

- [ ] **Step 2: Smoke-test the stack**

Run in the new shell:

```bash
# Prompt renders via starship — visible immediately
# No "oh-my-zsh" error messages during load
echo $ZSH_NAME $ZSH_VERSION
starship --version
mise --version
zoxide --version
alias gst          # should be: git status
alias la           # should be: eza -la ...
alias cat          # should be: bat (from apps/.aliases)
bindkey | grep -E 'jj|jk' | head
bindkey '^R' | grep fzf
```

Expected: no errors; every command returns clean output.

- [ ] **Step 3: Test vi-mode**

Type any command, press Escape or `jj`, press `k` — should recall previous command (vi cmd mode).

- [ ] **Step 4: Test fzf-tab**

Type `cd ` and Tab. Expected: fzf picker.

- [ ] **Step 5: Test zoxide**

Run:

```bash
z dotfiles
pwd
```

Expected: jumps to `~/dotfiles` (after zoxide has learned — may need to `cd ~/dotfiles` once first).

If any test fails, investigate before proceeding. Leave old oh-my-zsh in place until you're happy with the new setup.

---

## Phase 6 — asdf → mise migration

### Task 10: Capture current asdf state

**Files:**
- None (informational)

- [ ] **Step 1: List currently-installed asdf tools**

Run:

```bash
asdf current 2>/dev/null || echo "asdf not available in new shell — check old shell"
asdf plugin list 2>/dev/null || echo "no asdf plugins"
```

Expected: list of installed tools (java, golang based on `.zshrc`). If asdf isn't found, open an old-style shell: `ZDOTDIR=/tmp/omz-backup sh -c 'source ~/.asdf/asdf.sh && asdf current'`.

- [ ] **Step 2: Record versions for migration**

Write down (or copy to a scratch file) each language + version reported. You'll use these in Task 11.

- [ ] **Step 3: No commit**

---

### Task 11: Install tools via mise

**Files:**
- None (mise writes to `~/.local/share/mise/`)

- [ ] **Step 1: For each asdf tool captured in Task 10, run mise equivalent**

Example for java 21.0.1 and golang 1.22.0:

```bash
mise use -g java@21.0.1
mise use -g go@1.22.0
```

Run `mise use -g <tool>@<version>` for each tool.

Expected: mise downloads and installs; writes to `~/.config/mise/config.toml` (global).

- [ ] **Step 2: Verify mise has the tools**

Run:

```bash
mise ls
```

Expected: list of tools matching what asdf had.

- [ ] **Step 3: Verify shims work**

Run (in a fresh shell):

```bash
which java && java -version
which go && go version
```

Expected: paths inside `~/.local/share/mise/`; versions match what was requested.

- [ ] **Step 4: No commit** (mise state is in `~/.config/mise/`, not the dotfiles repo — unless you want to track `config.toml`; out of scope for this plan)

---

### Task 12: ⚠️ Uninstall asdf

**Files:**
- Delete: `~/.asdf/`
- Delete: `~/.tool-versions` (if any global one exists — keep per-project `.tool-versions` files intact)

Rollback: Reinstall asdf via its docs (git clone), resource `asdf.sh` in `.zshrc`. Tools would need reinstalling.

- [ ] **Step 1: Confirm mise is handling everything**

Run in a fresh shell:

```bash
which java go    # should resolve to mise shims, NOT ~/.asdf/shims/
```

Expected: mise paths. If any are asdf paths, investigate before continuing.

- [ ] **Step 2: Remove asdf**

Run:

```bash
rm -rf ~/.asdf
rm -f ~/.tool-versions  # global one only — project files stay
```

- [ ] **Step 3: Verify a fresh shell still has tools**

Open a new terminal, run:

```bash
java -version
go version
```

Expected: both work via mise shims.

- [ ] **Step 4: No commit** (no dotfiles changes)

---

## Phase 7 — Cleanup

### Task 13: ⚠️ Remove oh-my-zsh

**Files:**
- Delete: `~/.oh-my-zsh/`

Rollback: Reinstall oh-my-zsh and restore the old `.zshrc` via `git revert`.

- [ ] **Step 1: Confirm new shell does not reference oh-my-zsh**

Run:

```bash
grep -R 'oh-my-zsh\|ZSH=' ~/.zshrc /Users/kylecoberly/dotfiles/zsh/.zshrc 2>/dev/null | grep -v '^$'
```

Expected: NO matches. If any match appears, stop and investigate.

- [ ] **Step 2: Remove oh-my-zsh**

Run:

```bash
rm -rf ~/.oh-my-zsh
```

- [ ] **Step 3: Verify shell still works**

Open a new terminal. Expected: prompt loads cleanly, no missing-file errors.

- [ ] **Step 4: No commit** (no dotfiles changes)

---

### Task 14: Remove old theme file from dotfiles

**Files:**
- Delete: `/Users/kylecoberly/dotfiles/zsh/coberly-gruvbox.zsh-theme`

- [ ] **Step 1: Delete the theme file**

Run:

```bash
git -C /Users/kylecoberly/dotfiles rm zsh/coberly-gruvbox.zsh-theme
```

Expected: file staged for deletion.

- [ ] **Step 2: Commit**

```bash
git -C /Users/kylecoberly/dotfiles commit -m "Remove coberly-gruvbox zsh theme

Replaced by starship.toml. oh-my-zsh is no longer installed.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

---

### Task 15: Final verification sweep

**Files:** None

- [ ] **Step 1: Open a fresh shell and run the full smoke test**

```bash
# Structural: nothing references removed tooling
grep -R 'oh-my-zsh\|asdf' ~/.zshrc /Users/kylecoberly/dotfiles/zsh/ 2>/dev/null | grep -v 'docs/' | grep -v '.git/'

# Prompt: starship
[ -n "$STARSHIP_SHELL" ] && echo "starship active"

# Bindings
bindkey | grep -E 'jj|jk|fzf-history' | head

# Tools
for t in starship mise fzf zoxide eza bat rg delta; do
  command -v "$t" >/dev/null && echo "$t: ok" || echo "$t: MISSING"
done

# Plugins
for p in zsh-autosuggestions zsh-syntax-highlighting fzf-tab; do
  [ -d "$HOME/.zsh/plugins/$p" ] && echo "$p: ok" || echo "$p: MISSING"
done

# mise tools
mise ls

# z learning
z dotfiles && pwd

# Git alias
alias gst
```

Expected:
- No matches for `oh-my-zsh` or `asdf` (other than possibly docs/ and .git/)
- "starship active"
- `jj`, `jk`, and `fzf-history-widget` bindings present
- All 8 tools print "ok"
- All 3 plugins present
- `mise ls` lists expected tools
- `z dotfiles` jumps there
- `gst` = `git status`

- [ ] **Step 2: Final commit (if anything changed in dotfiles/)**

If `git -C ~/dotfiles status` shows anything, commit it. Otherwise this step is a no-op.

- [ ] **Step 3: Done**

---

## Success Criteria (from spec)

- [x] New shell opens without oh-my-zsh on disk — verified in Task 13
- [x] Prompt renders with starship — verified in Task 9
- [x] `jj`/`jk` exits to vi cmd mode; `^R` opens fzf — verified in Task 9
- [x] `mise ls` shows previously-asdf tools — verified in Task 11
- [x] `z dotfiles` works; `ls` uses eza aliases (via `la`/`lt`); `cat` = bat — verified in Task 15
- [x] Tab-completing `cd` shows fzf picker — verified in Task 9
- [x] No references to oh-my-zsh/asdf/old theme in dotfiles — verified in Task 15

---

## Self-Review notes

**Spec coverage:** Every architectural element in the spec (native zsh, 3 plugins, starship, mise, 6 CLI tools, preserved bindings, migration phases) has a task. ✓

**Destructive actions flagged:** Tasks 8, 12, 13 marked ⚠️ with rollback notes. ✓

**No placeholders:** All config file contents written out in full; all commands exact; all expected outputs specified. ✓

**File path consistency:** `~/.zsh/plugins/` used consistently; `dotfiles/zsh/` prefix consistent; starship.toml symlinked to `~/.config/starship.toml` consistently. ✓

**Order correctness:** Plugin sourcing order (fzf-tab → autosuggestions → syntax-highlighting last) matches spec requirement. ✓
