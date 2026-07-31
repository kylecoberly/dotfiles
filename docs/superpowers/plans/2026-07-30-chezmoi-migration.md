# Chezmoi Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the symlink-based dotfiles system with a purist chezmoi source tree that syncs across the MacBook Air and Serena, routes Claude plans/artifacts into the Obsidian vault per account, and drops the Linux-desktop remnants.

**Architecture:** The existing repo (kept checked out at `~/dotfiles`, used as chezmoi's `sourceDir`) is transformed in place on a `chezmoi` branch: configs move to chezmoi source naming (`dot_*`), OS differences move into templates and `.chezmoiignore`, external plugin repos into `.chezmoiexternal.toml`, and installers into `run_onchange_` scripts. Claude hooks get an account-aware vault-routing library with shell tests. A timer-driven sync script captures runtime-mutated files (`chezmoi re-add`) then pulls/applies/pushes.

**Tech Stack:** chezmoi (Go templates), bash, jq, launchd (Mac) / systemd user timers (Serena), Homebrew / apt.

## Global Constraints

- Purist chezmoi: no symlink-mode files; applied files are real files.
- Repo stays at `~/dotfiles` and remains the chezmoi source dir (configs reference `~/dotfiles/theme/...` and must keep working).
- One-command setup: `chezmoi init --source ~/dotfiles --apply git@github.com:kylecoberly/dotfiles.git`.
- Account mapping (exact): `kyle.coberly@gmail.com` → `personal`, `kcoberly@nsls.org` → `work`, unknown email → lowercased, non-alphanumerics collapsed to `-`; no email readable → `unknown`.
- Vault resolution order (exact): `$OBSIDIAN_VAULT` (if the dir exists) → `/mnt/files/application-data/obsidian/notes` → `$HOME/Documents/notes`; hooks silently no-op when none exists.
- Vault paths: plans `zz_/plans/<account>/<project>/`, artifacts `zz_/artifacts/<account>/<project>/`.
- Keep: nvim, tmux, theme system, aerospace/karabiner/sketchybar/peon, Brewfile. Drop: Linux desktop packages/integration, Codespaces support, old install.sh scripts.
- Git: new commits only, never `--force`/`--no-verify`; all work on branch `chezmoi` (branched from `master`); master later fast-forwards, so never commit to master directly during this plan.
- Never run `chezmoi apply` against the real `$HOME` until Task 13 (cutover). All prior verification uses the sandbox script from Task 1.
- All new shell files: `#!/usr/bin/env bash` + `set -euo pipefail` (except where noted).

---

### Task 1: Branch, chezmoi install, scaffolding, sandbox harness

**Files:**
- Create: `.chezmoi.toml.tmpl`, `.chezmoiignore.tmpl`, `tests/sandbox-apply.sh`, `tests/run.sh`
- Create: `machine/` directory (repo tooling, never applied to `$HOME`)

**Interfaces:**
- Produces: `tests/sandbox-apply.sh` — prints the path of a temp dir that chezmoi has applied the source into (scripts and externals excluded). Every later task's verification uses it.
- Produces: `tests/run.sh` — runs every `tests/test-*.sh`, exits non-zero on any failure.

- [ ] **Step 1: Branch and install chezmoi**

```bash
cd ~/dotfiles
git checkout -b chezmoi
command -v chezmoi >/dev/null 2>&1 || brew install chezmoi
chezmoi --version
```

- [ ] **Step 2: Write `.chezmoi.toml.tmpl`**

```toml
{{/* Rendered to ~/.config/chezmoi/chezmoi.toml by `chezmoi init`. */}}
sourceDir = {{ .chezmoi.workingTree | quote }}

[git]
    autoCommit = true
    autoPush = true
```

- [ ] **Step 3: Write `.chezmoiignore.tmpl`**

Repo-tooling dirs are never applied; mac-only trees are skipped on Linux and vice versa. (Files whose names start with `.` — `.gitignore`, `.claude/`, `docs` is not one — are ignored by chezmoi automatically; everything listed here is not.)

```
README.md
docs
theme
tests
machine
{{ if ne .chezmoi.os "darwin" }}
.config/aerospace
.config/karabiner
.config/sketchybar
Library
{{ end }}
{{ if ne .chezmoi.os "linux" }}
.config/systemd
{{ end }}
```

- [ ] **Step 4: Write `tests/sandbox-apply.sh`**

```bash
#!/usr/bin/env bash
# Apply the repo's chezmoi source into a throwaway destination and print it.
# Excludes run_ scripts (no package installs) and externals (no network).
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SANDBOX="${1:-$(mktemp -d)}"
chezmoi apply --source "$REPO" --destination "$SANDBOX" \
  --exclude scripts,externals --force >/dev/null
echo "$SANDBOX"
```

- [ ] **Step 5: Write `tests/run.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
status=0
for t in "$DIR"/test-*.sh; do
  [ -e "$t" ] || continue
  if bash "$t"; then echo "PASS $(basename "$t")"; else echo "FAIL $(basename "$t")"; status=1; fi
done
exit $status
```

- [ ] **Step 6: Verify sandbox works on the empty source**

```bash
chmod +x tests/sandbox-apply.sh tests/run.sh
SANDBOX=$(tests/sandbox-apply.sh)
ls -A "$SANDBOX"   # expect: empty (nothing managed yet)
```

- [ ] **Step 7: Commit**

```bash
git add .chezmoi.toml.tmpl .chezmoiignore.tmpl tests/ && git commit -m "chezmoi: scaffolding, ignore rules, sandbox test harness"
```

---

### Task 2: Shell layer — zsh, git, mise, starship, zsh-plugin externals

**Files:**
- Create (moves): `dot_zshrc`, `dot_config/zsh/aliases.zsh`, `dot_config/zsh/osc7.zsh`, `dot_config/starship.toml`, `dot_gitconfig`, `dot_gitignore`, `dot_asdfrc`, `dot_tool-versions`
- Create: `.chezmoiexternal.toml` (zsh plugins section)

**Interfaces:**
- Produces: applied `~/.zshrc` sourcing `~/.config/zsh/aliases.zsh` and `~/.config/zsh/osc7.zsh`; zsh plugins at `~/.zsh/plugins/<name>` (same paths `.zshrc` already uses).

- [ ] **Step 1: Move the files with history**

```bash
git mv shared/zsh/.zshrc dot_zshrc
mkdir -p dot_config/zsh
git mv shared/zsh/aliases.zsh dot_config/zsh/aliases.zsh
git mv shared/zsh/osc7.zsh dot_config/zsh/osc7.zsh
git mv shared/zsh/starship.toml dot_config/starship.toml
git mv shared/git/.gitconfig dot_gitconfig
git mv shared/git/.gitignore dot_gitignore
git mv shared/mise/.asdfrc dot_asdfrc
git mv shared/mise/.tool-versions dot_tool-versions
```

- [ ] **Step 2: Repoint repo-path references in `dot_zshrc`**

```bash
grep -n 'DOTFILES\|dotfiles' dot_zshrc
```

For every hit that sources or references a file that now has an applied location, change it to the applied path — specifically `.../shared/zsh/aliases.zsh` → `$HOME/.config/zsh/aliases.zsh` and `.../shared/zsh/osc7.zsh` → `$HOME/.config/zsh/osc7.zsh`. References to `~/dotfiles/theme/...` stay (theme lives in the repo by design). Remove any `DOTFILES=` export whose only remaining consumers were the deleted install scripts; keep it if anything else still reads it.

- [ ] **Step 3: Check `shared/mise/languages.json` for consumers, then drop or keep**

```bash
grep -rn 'languages.json' --exclude-dir=.git .
```

If nothing references it, `git rm shared/mise/languages.json`. If something does, move it to `machine/languages.json` and update the reference.

- [ ] **Step 4: Write the zsh-plugins section of `.chezmoiexternal.toml`**

```toml
[".zsh/plugins/zsh-autosuggestions"]
    type = "git-repo"
    url = "https://github.com/zsh-users/zsh-autosuggestions.git"
    refreshPeriod = "168h"

[".zsh/plugins/zsh-syntax-highlighting"]
    type = "git-repo"
    url = "https://github.com/zsh-users/zsh-syntax-highlighting.git"
    refreshPeriod = "168h"

[".zsh/plugins/fzf-tab"]
    type = "git-repo"
    url = "https://github.com/Aloxaf/fzf-tab.git"
    refreshPeriod = "168h"
```

- [ ] **Step 5: Verify via sandbox**

```bash
SANDBOX=$(tests/sandbox-apply.sh)
test -f "$SANDBOX/.zshrc" && test -f "$SANDBOX/.config/zsh/aliases.zsh" \
  && test -f "$SANDBOX/.config/starship.toml" && test -f "$SANDBOX/.gitconfig" \
  && test -f "$SANDBOX/.tool-versions" && echo OK
zsh -n dot_zshrc   # syntax check
```

- [ ] **Step 6: Commit**

```bash
git add -A && git commit -m "chezmoi: port shell layer (zsh, git, mise, starship), zsh plugins as externals"
```

---

### Task 3: Terminal & editors — alacritty, nvim, tmux (+ externals)

**Files:**
- Create (moves): `dot_config/alacritty/alacritty.toml`, `dot_config/nvim/**`, `dot_config/tmux/tmux.conf`, `dot_config/tmux/scripts/*`
- Create: `dot_config/alacritty/palette.toml` (copy of `theme/palette.toml`)
- Modify: `.chezmoiexternal.toml` (tmux plugins), `dot_config/nvim/lua/plugins/tokyonight.lua`
- Create: `run_onchange_after_50-build-tmux-thumbs.sh.tmpl`

**Interfaces:**
- Consumes: sandbox harness from Task 1.
- Produces: applied `~/.config/alacritty/alacritty.toml` importing `~/.config/alacritty/palette.toml`; tmux plugins at `~/.config/tmux/plugins/<name>` (paths `tmux.conf` already loads).

- [ ] **Step 1: Move alacritty and add the palette as a managed file**

```bash
mkdir -p dot_config/alacritty
git mv shared/alacritty/alacritty.toml dot_config/alacritty/alacritty.toml
cp theme/palette.toml dot_config/alacritty/palette.toml
git add dot_config/alacritty/palette.toml
```

In `dot_config/alacritty/alacritty.toml`, change line 2 from
`import = ["~/dotfiles/theme/palette.toml"]` to
`import = ["~/.config/alacritty/palette.toml"]`.

- [ ] **Step 2: Move nvim and fix the palette lookup**

```bash
git mv shared/nvim dot_config/nvim
```

`dot_config/nvim/lua/plugins/tokyonight.lua` currently derives the repo root by walking up from the config's symlink real-path — that breaks once `~/.config/nvim` is a real directory. Replace the resolution block (the `local real ... local dotfiles_root ... pcall(dofile, ...)` lines at the top) with a direct load:

```lua
local ok, palette = pcall(dofile, vim.fs.normalize("~/dotfiles/theme/palette.lua"))
```

Keep the existing `if not ok` fallback behavior that follows.

- [ ] **Step 3: Move tmux config and scripts; plugins become externals**

```bash
mkdir -p dot_config/tmux
git mv shared/tmux/tmux.conf dot_config/tmux/tmux.conf
git mv shared/tmux/scripts dot_config/tmux/scripts
git rm -r --cached shared/tmux 2>/dev/null || true
git rm shared/tmux/.gitignore
rm -rf shared/tmux   # vendored plugin checkouts, untracked
```

Confirm each plugin's upstream before writing externals (vendored checkouts still exist on disk in `~/dotfiles/shared/tmux/plugins` until the `rm -rf` — run this first):

```bash
for p in ~/dotfiles/shared/tmux/plugins/*/; do git -C "$p" remote get-url origin; done
```

Append to `.chezmoiexternal.toml`, one entry per plugin found (expected set below — correct any URL that disagrees with the command output):

```toml
[".config/tmux/plugins/tmux-autoreload"]
    type = "git-repo"
    url = "https://github.com/b0o/tmux-autoreload.git"
    refreshPeriod = "168h"

[".config/tmux/plugins/tmux-continuum"]
    type = "git-repo"
    url = "https://github.com/tmux-plugins/tmux-continuum.git"
    refreshPeriod = "168h"

[".config/tmux/plugins/tmux-floax"]
    type = "git-repo"
    url = "https://github.com/omerxx/tmux-floax.git"
    refreshPeriod = "168h"

[".config/tmux/plugins/tmux-nova"]
    type = "git-repo"
    url = "https://github.com/o0th/tmux-nova.git"
    refreshPeriod = "168h"

[".config/tmux/plugins/tmux-open"]
    type = "git-repo"
    url = "https://github.com/tmux-plugins/tmux-open.git"
    refreshPeriod = "168h"

[".config/tmux/plugins/tmux-resurrect"]
    type = "git-repo"
    url = "https://github.com/tmux-plugins/tmux-resurrect.git"
    refreshPeriod = "168h"

[".config/tmux/plugins/tmux-sessionx"]
    type = "git-repo"
    url = "https://github.com/omerxx/tmux-sessionx.git"
    refreshPeriod = "168h"

[".config/tmux/plugins/tmux-thumbs"]
    type = "git-repo"
    url = "https://github.com/fcsonline/tmux-thumbs.git"
    refreshPeriod = "168h"
```

- [ ] **Step 4: tmux-thumbs build script (it ships Rust source, not a binary)**

Create `run_onchange_after_50-build-tmux-thumbs.sh.tmpl`:

```bash
#!/usr/bin/env bash
# tmux-thumbs is cloned by .chezmoiexternal.toml but must be compiled once.
set -euo pipefail
THUMBS="$HOME/.config/tmux/plugins/tmux-thumbs"
[ -d "$THUMBS" ] || exit 0
[ -x "$THUMBS/target/release/tmux-thumbs" ] && exit 0
if command -v cargo >/dev/null 2>&1; then
  (cd "$THUMBS" && cargo build --release)
else
  echo "tmux-thumbs: cargo not found — install rust (e.g. via mise) and re-run 'chezmoi apply'" >&2
fi
```

- [ ] **Step 5: Verify via sandbox + syntax checks**

```bash
SANDBOX=$(tests/sandbox-apply.sh)
test -f "$SANDBOX/.config/alacritty/alacritty.toml" \
  && test -f "$SANDBOX/.config/alacritty/palette.toml" \
  && test -f "$SANDBOX/.config/nvim/init.lua" \
  && test -f "$SANDBOX/.config/tmux/tmux.conf" \
  && test -x "$SANDBOX/.config/tmux/scripts/git-branch.sh" && echo OK
```

If `scripts/*.sh` came out non-executable, rename them in the source with chezmoi's attribute prefix, e.g. `chezmoi chattr +executable` equivalent by renaming: `git mv dot_config/tmux/scripts/git-branch.sh dot_config/tmux/scripts/executable_git-branch.sh` (repeat for `spawn-pane.sh`, `ssh-host.sh`).

- [ ] **Step 6: Commit**

```bash
git add -A && git commit -m "chezmoi: port alacritty/nvim/tmux; tmux plugins as externals with thumbs build script"
```

---

### Task 4: Theme regenerator path updates

**Files:**
- Modify: `theme/regenerate.sh`, `theme/README.md`

**Interfaces:**
- Consumes: `dot_config/alacritty/palette.toml` and `dot_config/starship.toml` created in Tasks 2–3.
- Produces: `./theme/regenerate.sh` writes `theme/palette.lua`, `dot_config/alacritty/palette.toml`, and the marker block in `dot_config/starship.toml`, then reminds to `chezmoi apply`.

- [ ] **Step 1: Update output paths in `theme/regenerate.sh`**

- The `palette.toml` heredoc target changes from `$THEME_DIR/palette.toml` to `$DOTFILES/dot_config/alacritty/palette.toml`.
- The starship marker-block edit changes from `$DOTFILES/shared/zsh/starship.toml` to `$DOTFILES/dot_config/starship.toml`.
- `theme/palette.lua` output is unchanged (nvim reads it from `~/dotfiles/theme/` directly).
- Delete `theme/palette.toml` (`git rm theme/palette.toml`) — its only consumer now reads the managed copy.
- Add as the script's last line:

```bash
echo "→ regenerated. Run 'chezmoi apply' to propagate to ~/.config."
```

- [ ] **Step 2: Update `theme/README.md`** to describe the new outputs (same three bullets as Step 1).

- [ ] **Step 3: Verify**

```bash
./theme/regenerate.sh
git diff --stat   # expect only dot_config/alacritty/palette.toml, dot_config/starship.toml, theme/palette.lua timestamps/content
```

- [ ] **Step 4: Commit**

```bash
git add -A && git commit -m "theme: regenerate into chezmoi-managed targets"
```

---

### Task 5: Vault/account/project resolver with tests (TDD)

**Files:**
- Create: `dot_claude/scripts/executable_vault-target.sh`
- Test: `tests/test-vault-target.sh`

**Interfaces:**
- Produces (sourced): `resolve_vault` (prints vault dir or returns 1), `resolve_account` (prints slug, never fails), `resolve_project <cwd>` (prints project name).
- Produces (executed): prints `"<vault> <account> <project>"` on one line; first CLI arg overrides cwd. Env overrides: `OBSIDIAN_VAULT` (vault), `CLAUDE_JSON` (path to the file normally at `~/.claude.json`).
- Consumed by: Task 6 hook (sourced at `~/.claude/scripts/vault-target.sh`), Task 7 commands (executed).

- [ ] **Step 1: Write the failing test `tests/test-vault-target.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "FAIL: $1" >&2; exit 1; }
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

source "$REPO/dot_claude/scripts/executable_vault-target.sh"

# account mapping
echo '{"oauthAccount":{"emailAddress":"kcoberly@nsls.org"}}' > "$TMP/claude.json"
[ "$(CLAUDE_JSON=$TMP/claude.json resolve_account)" = "work" ] || fail "work mapping"
echo '{"oauthAccount":{"emailAddress":"kyle.coberly@gmail.com"}}' > "$TMP/claude.json"
[ "$(CLAUDE_JSON=$TMP/claude.json resolve_account)" = "personal" ] || fail "personal mapping"
echo '{"oauthAccount":{"emailAddress":"Someone.Else@Corp.IO"}}' > "$TMP/claude.json"
[ "$(CLAUDE_JSON=$TMP/claude.json resolve_account)" = "someone-else-corp-io" ] || fail "sanitized fallback"
[ "$(CLAUDE_JSON=$TMP/absent.json resolve_account)" = "unknown" ] || fail "missing file → unknown"

# vault resolution
mkdir "$TMP/vault"
[ "$(OBSIDIAN_VAULT=$TMP/vault HOME=$TMP resolve_vault)" = "$TMP/vault" ] || fail "explicit vault wins"
if OBSIDIAN_VAULT=$TMP/nope HOME=$TMP resolve_vault >/dev/null 2>&1; then fail "no vault should return 1"; fi
mkdir -p "$TMP/Documents/notes"
[ "$(OBSIDIAN_VAULT=$TMP/nope HOME=$TMP resolve_vault)" = "$TMP/Documents/notes" ] || fail "home fallback"

# project resolution
mkdir -p "$TMP/proj/sub" && git -C "$TMP/proj" init -q
[ "$(resolve_project "$TMP/proj/sub")" = "proj" ] || fail "git repo basename"
[ "$(HOME=$TMP resolve_project "$TMP")" = "home" ] || fail "cwd == HOME → home"
mkdir -p "$TMP/loose dir"
[ "$(resolve_project "$TMP/loose dir")" = "loose dir" ] || fail "plain cwd basename"

echo ok
```

- [ ] **Step 2: Run it — expect failure**

```bash
bash tests/test-vault-target.sh
```

Expected: fails with "No such file or directory" sourcing the script.

- [ ] **Step 3: Write `dot_claude/scripts/executable_vault-target.sh`**

```bash
#!/usr/bin/env bash
# Resolve the Obsidian vault, active Claude account slug, and project name.
# Sourced by hooks; executed directly by slash commands
# (prints "<vault> <account> <project>", arg 1 = cwd override).
# Env overrides for tests: OBSIDIAN_VAULT, CLAUDE_JSON.

resolve_vault() {
  if [ -n "${OBSIDIAN_VAULT:-}" ] && [ -d "$OBSIDIAN_VAULT" ]; then
    echo "$OBSIDIAN_VAULT"; return 0
  fi
  if [ -d /mnt/files/application-data/obsidian/notes ]; then
    echo /mnt/files/application-data/obsidian/notes; return 0
  fi
  if [ -d "$HOME/Documents/notes" ]; then
    echo "$HOME/Documents/notes"; return 0
  fi
  return 1
}

resolve_account() {
  local claude_json="${CLAUDE_JSON:-$HOME/.claude.json}"
  local email=""
  if [ -f "$claude_json" ]; then
    email=$(jq -r '.oauthAccount.emailAddress // empty' "$claude_json" 2>/dev/null || true)
  fi
  case "$email" in
    kyle.coberly@gmail.com) echo personal ;;
    kcoberly@nsls.org)      echo work ;;
    "")                     echo unknown ;;
    *) printf '%s' "$email" | tr '[:upper:]' '[:lower:]' \
         | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//' ;;
  esac
}

resolve_project() {
  local cwd="${1:-$PWD}" repo_root
  if repo_root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null); then
    basename "$repo_root"
  elif [ "$cwd" = "$HOME" ]; then
    echo home
  else
    basename "$cwd"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  set -euo pipefail
  echo "$(resolve_vault) $(resolve_account) $(resolve_project "${1:-$PWD}")"
fi
```

(No `set -euo pipefail` at the top: this file is sourced by scripts that own their shell options.)

- [ ] **Step 4: Run tests — expect pass**

```bash
bash tests/test-vault-target.sh   # expect: ok
```

- [ ] **Step 5: Commit**

```bash
git add dot_claude/scripts tests/test-vault-target.sh && git commit -m "claude: account-aware vault target resolver with tests"
```

---

### Task 6: Rewrite the save-plan hook (TDD)

**Files:**
- Create: `dot_claude/hooks/save-plan/executable_save-plan.sh` (replaces `shared/claude/hooks/save-plan/save-plan.sh`)
- Test: `tests/test-save-plan.sh`

**Interfaces:**
- Consumes: `resolve_vault`/`resolve_account`/`resolve_project` by sourcing `~/.claude/scripts/vault-target.sh` (applied path, relative: `$SCRIPT_DIR/../../scripts/vault-target.sh`).
- Produces: on ExitPlanMode PostToolUse, writes `<vault>/zz_/plans/<account>/<project>/<YYYY-MM-DD-HHMMSS>-<slug>.md`.

- [ ] **Step 1: Write the failing test `tests/test-save-plan.sh`**

The hook sources a sibling by applied-tree layout, so the test runs against a sandbox apply, with `HOME` pointed at an isolated dir so real vault fallbacks can't leak in.

```bash
#!/usr/bin/env bash
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "FAIL: $1" >&2; exit 1; }
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

SANDBOX=$("$REPO/tests/sandbox-apply.sh")
HOOK="$SANDBOX/.claude/hooks/save-plan/save-plan.sh"
[ -x "$HOOK" ] || fail "hook missing or not executable in applied tree"

VAULT="$TMP/vault"; mkdir -p "$VAULT"
echo '{"oauthAccount":{"emailAddress":"kyle.coberly@gmail.com"}}' > "$TMP/claude.json"
mkdir -p "$TMP/myproj" && git -C "$TMP/myproj" init -q

printf '{"tool_input":{"plan":"# Test Plan Title\n\nBody."},"cwd":"%s"}' "$TMP/myproj" \
  | HOME="$TMP" OBSIDIAN_VAULT="$VAULT" CLAUDE_JSON="$TMP/claude.json" "$HOOK"

FILE=$(ls "$VAULT/zz_/plans/personal/myproj/"*-test-plan-title.md) || fail "plan file not written"
grep -q '^account: personal$' "$FILE" || fail "frontmatter missing account"
grep -q '^# Test Plan Title$' "$FILE" || fail "plan body missing"

# no vault → silent no-op, exit 0
printf '{"tool_input":{"plan":"# X"},"cwd":"%s"}' "$TMP" \
  | HOME="$TMP/nohome" OBSIDIAN_VAULT="$TMP/nope" CLAUDE_JSON="$TMP/claude.json" "$HOOK" \
  || fail "missing vault must exit 0"

# empty plan → no file
printf '{"cwd":"%s"}' "$TMP/myproj" \
  | HOME="$TMP" OBSIDIAN_VAULT="$VAULT" CLAUDE_JSON="$TMP/claude.json" "$HOOK" \
  || fail "empty plan must exit 0"

echo ok
```

- [ ] **Step 2: Run it — expect failure** (`hook missing`)

```bash
bash tests/test-save-plan.sh
```

- [ ] **Step 3: Write the hook and remove the old one**

```bash
mkdir -p dot_claude/hooks/save-plan
git rm shared/claude/hooks/save-plan/save-plan.sh
```

`dot_claude/hooks/save-plan/executable_save-plan.sh`:

```bash
#!/usr/bin/env bash
# PostToolUse hook for ExitPlanMode: file the approved plan into the
# Obsidian vault under zz_/plans/<account>/<project>/.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../scripts/executable_vault-target.sh
source "$SCRIPT_DIR/../../scripts/vault-target.sh"

VAULT=$(resolve_vault) || exit 0

INPUT=$(cat)
PLAN=$(printf '%s' "$INPUT" | jq -r '.tool_input.plan // empty')
CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // empty')
[ -z "$PLAN" ] && exit 0
[ -z "$CWD" ] && CWD=$PWD

ACCOUNT=$(resolve_account)
PROJECT=$(resolve_project "$CWD")
PLANS_DIR="$VAULT/zz_/plans/$ACCOUNT/$PROJECT"
mkdir -p "$PLANS_DIR"

TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)
TITLE=$(printf '%s\n' "$PLAN" | grep -m1 '^#' | sed 's/^#\+ *//' || true)
[ -z "$TITLE" ] && TITLE=$(printf '%s\n' "$PLAN" | grep -m1 '[^[:space:]]' || true)
SLUG=$(printf '%s' "$TITLE" | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//' | cut -c1-60)
[ -z "$SLUG" ] && SLUG="plan"

{
  printf -- '---\n'
  printf 'created: %s\n' "$(date -Iseconds)"
  printf 'cwd: %s\n' "$CWD"
  printf 'account: %s\n' "$ACCOUNT"
  printf 'source: claude-code\n'
  printf -- '---\n\n'
  printf '%s\n' "$PLAN"
} > "$PLANS_DIR/${TIMESTAMP}-${SLUG}.md"
```

- [ ] **Step 4: Run tests — expect pass**

```bash
bash tests/test-save-plan.sh && bash tests/run.sh
```

- [ ] **Step 5: Commit**

```bash
git add -A && git commit -m "claude: save-plan routes to zz_/plans/<account>/<project> in the vault"
```

---

### Task 7: /load-plan update and new /save-artifact command

**Files:**
- Create (move+rewrite): `dot_claude/commands/load-plan.md` (from `shared/claude/commands/load-plan.md`)
- Create: `dot_claude/commands/save-artifact.md`

**Interfaces:**
- Consumes: `~/.claude/scripts/vault-target.sh` executed directly (prints `<vault> <account> <project>`).

- [ ] **Step 1: Move and rewrite `load-plan.md`**

```bash
git mv shared/claude/commands/load-plan.md dot_claude/commands/load-plan.md
git rm shared/claude/commands/.gitkeep shared/claude/agents/.gitkeep shared/claude/skills/.gitkeep
```

New content for `dot_claude/commands/load-plan.md`:

````markdown
---
description: Load a previously saved plan from the Obsidian vault for the current context
argument-hint: [optional search hint]
---

Load a relevant saved plan from the Obsidian vault.

## Steps

1. Resolve vault, account, and project in one shot:
   ```bash
   read -r VAULT ACCOUNT PROJECT <<< "$(~/.claude/scripts/vault-target.sh)"
   ```
   If the script exits non-zero, tell the user no vault is available on this machine and stop.

2. List candidates, newest first (filenames are timestamp-prefixed):
   ```bash
   ls -1t "$VAULT/zz_/plans/$ACCOUNT/$PROJECT/" 2>/dev/null
   ```

3. If `$ARGUMENTS` is non-empty, filter to filenames or contents matching the hint (`rg -l` in that directory).

4. If exactly one plan matches, Read it and summarize. If several match, list them with the first heading of each and ask which to load. If none match, say so and offer the full directory listing (also check the legacy flat `$VAULT/zz_/plans/$PROJECT/` layout for pre-migration plans).

5. Once chosen, Read the plan and treat it as established context for the session.

Argument (optional search hint): $ARGUMENTS
````

- [ ] **Step 2: Write `dot_claude/commands/save-artifact.md`**

````markdown
---
description: File a deliverable into the Obsidian vault under zz_/artifacts, per account and project
argument-hint: <file> [description]
---

Save a file Claude produced (or any file the user names) into the Obsidian vault.

## Steps

1. Parse `$ARGUMENTS`: first token is the source file path, the rest (optional) is a human description. If no file is given or it doesn't exist, ask for it and stop.

2. Resolve the destination:
   ```bash
   read -r VAULT ACCOUNT PROJECT <<< "$(~/.claude/scripts/vault-target.sh)"
   DEST_DIR="$VAULT/zz_/artifacts/$ACCOUNT/$PROJECT"
   mkdir -p "$DEST_DIR"
   ```
   If the script exits non-zero, tell the user no vault is available on this machine and stop.

3. Copy, keeping the original basename. For a `.md` source, write a copy with frontmatter prepended; anything else is copied verbatim:
   ```bash
   SRC="<file from step 1>"
   BASE="$(basename "$SRC")"
   if [[ "$BASE" == *.md ]]; then
     {
       printf -- '---\ncreated: %s\nsource: %s\nproject: %s\n' "$(date -Iseconds)" "$SRC" "$PROJECT"
       [ -n "<description>" ] && printf 'description: %s\n' "<description>"
       printf -- '---\n\n'
       cat "$SRC"
     } > "$DEST_DIR/$BASE"
   else
     cp "$SRC" "$DEST_DIR/$BASE"
   fi
   ```
   If `$DEST_DIR/$BASE` already exists, append `-2`, `-3`, … before the extension rather than overwriting.

4. Report the final vault path to the user.
````

- [ ] **Step 3: Verify commands land in the applied tree**

```bash
SANDBOX=$(tests/sandbox-apply.sh)
test -f "$SANDBOX/.claude/commands/load-plan.md" && test -f "$SANDBOX/.claude/commands/save-artifact.md" && echo OK
```

- [ ] **Step 4: Commit**

```bash
git add -A && git commit -m "claude: account-aware /load-plan and new /save-artifact"
```

---

### Task 8: Remaining Claude config — settings, CLAUDE.md, statusline, peon config

**Files:**
- Create (moves): `dot_claude/settings.json`, `dot_claude/CLAUDE.md`, `dot_claude/executable_statusline-command.sh`, `dot_claude/hooks/peon-ping/config.json`

**Interfaces:**
- Produces: applied `~/.claude/settings.json` with the existing hooks config (paths in it are `$HOME/.claude/...`-relative and stay valid).
- Produces: statusline shows a `⚠ sync` marker when `~/.cache/chezmoi-sync/last-error` exists (consumed by Task 11's sync script).

- [ ] **Step 1: Move the files**

```bash
git mv shared/claude/settings.json dot_claude/settings.json
git mv shared/claude/CLAUDE.md dot_claude/CLAUDE.md
git mv shared/claude/statusline-command.sh dot_claude/executable_statusline-command.sh
mkdir -p dot_claude/hooks/peon-ping
git mv shared/claude/hooks/peon-ping/config.json dot_claude/hooks/peon-ping/config.json
git rm -r shared/claude 2>/dev/null; rm -rf shared/claude
```

(`settings.json` hook commands reference `$HOME/.claude/hooks/...` and `~/.claude/statusline-command.sh` — unchanged applied paths, so no content edits needed.)

- [ ] **Step 2: Add the sync-warning marker to the statusline**

Read `dot_claude/executable_statusline-command.sh`; near the top add:

```bash
SYNC_WARN=""
[ -f "$HOME/.cache/chezmoi-sync/last-error" ] && SYNC_WARN="⚠ sync "
```

and prepend `${SYNC_WARN}` to the first segment of the line the script ultimately prints (locate the final `printf`/`echo` that emits the statusline and lead with it).

- [ ] **Step 3: Verify**

```bash
SANDBOX=$(tests/sandbox-apply.sh)
test -f "$SANDBOX/.claude/settings.json" && test -x "$SANDBOX/.claude/statusline-command.sh" \
  && test -f "$SANDBOX/.claude/hooks/peon-ping/config.json" && echo OK
jq empty dot_claude/settings.json
mkdir -p "$SANDBOX/.cache/chezmoi-sync" && touch "$SANDBOX/.cache/chezmoi-sync/last-error"
HOME="$SANDBOX" bash "$SANDBOX/.claude/statusline-command.sh" <<< '{}' | grep -q '⚠ sync' && echo WARN-OK
```

(If the statusline script requires richer stdin JSON, feed it the minimal shape it parses — read the script to see — the assertion is only that `⚠ sync` appears when the error file exists.)

- [ ] **Step 4: Commit**

```bash
git add -A && git commit -m "chezmoi: port Claude settings/statusline; surface sync failures in statusline"
```

---

### Task 9: Package installers — Brewfile (darwin) and pared apt list (linux)

**Files:**
- Create (move): `machine/darwin/Brewfile` (from `macos/Brewfile`)
- Create (move): `machine/fonts/` (from `shared/fonts/`)
- Create: `run_onchange_10-packages-darwin.sh.tmpl`, `run_onchange_10-packages-linux.sh.tmpl`
- Delete: `linux/packages.txt`, `linux/install.sh`, `linux/alacritty/40-libinput.conf`, `macos/install.sh`, `shared/install.sh`, `install.sh`

**Interfaces:**
- Produces: `brew bundle` / apt runs re-trigger whenever the embedded package-list hash changes.

- [ ] **Step 1: Move Brewfile and fonts; delete dead installers**

```bash
mkdir -p machine/darwin machine/fonts
git mv macos/Brewfile machine/darwin/Brewfile
git mv "shared/fonts/Noto Mono Nerd Font Complete.ttf" "machine/fonts/Noto Mono Nerd Font Complete.ttf"
git rm linux/install.sh linux/packages.txt linux/alacritty/40-libinput.conf macos/install.sh shared/install.sh install.sh
git rm tmux-client-91252.log 2>/dev/null || rm -f tmux-client-91252.log
```

- [ ] **Step 2: Write `run_onchange_10-packages-darwin.sh.tmpl`**

```bash
{{ if eq .chezmoi.os "darwin" -}}
#!/usr/bin/env bash
# Re-runs when the Brewfile changes:
# Brewfile hash: {{ include "machine/darwin/Brewfile" | sha256sum }}
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
if [[ -x /usr/local/bin/brew ]]; then eval "$(/usr/local/bin/brew shellenv)"; fi

brew bundle --file="{{ .chezmoi.sourceDir }}/machine/darwin/Brewfile"

# Claude Code — native installer (self-updates; not the brew cask)
command -v claude >/dev/null 2>&1 || curl -fsSL https://claude.ai/install.sh | bash

# Font — per-user install, no sudo
mkdir -p "$HOME/Library/Fonts"
cp -f "{{ .chezmoi.sourceDir }}/machine/fonts/Noto Mono Nerd Font Complete.ttf" "$HOME/Library/Fonts/"
{{ end -}}
```

- [ ] **Step 3: Write `run_onchange_10-packages-linux.sh.tmpl`** (headless-server set: GUI apps, browsers, alacritty, VS Code/Chrome/Bruno repos, GNOME/X11 integration, fonts, obsidian/zoom/zen all dropped; Obsidian runs in its own desktop-emulator container on Serena)

```bash
{{ if eq .chezmoi.os "linux" -}}
#!/usr/bin/env bash
# Headless Ubuntu server packages. Re-runs when this file's content changes.
set -euo pipefail

sudo dpkg --configure -a
sudo apt-get update

# 1password-cli needs 1Password's apt repo
if [ ! -f /usr/share/keyrings/1password-archive-keyring.gpg ]; then
  curl -sS https://downloads.1password.com/linux/keys/1password.asc |
    sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' |
    sudo tee /etc/apt/sources.list.d/1password.list
  sudo apt-get update
fi

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold \
  zsh git curl wget jq zoxide bat ripgrep fd-find eza tldr tree htop ncdu \
  nmap ranger ffmpeg p7zip-full unzip imagemagick graphviz tcpdump whois \
  tmux gh git-delta entr pipx build-essential postgresql \
  autoconf bison libssl-dev libyaml-dev libreadline-dev libffi-dev \
  libgmp-dev libgdbm-dev libdb-dev libncurses-dev uuid-dev \
  1password-cli

# ── Tools without apt packages ──
command -v mise    >/dev/null 2>&1 || curl https://mise.run | sh
command -v starship >/dev/null 2>&1 || curl -sS https://starship.rs/install.sh | sh -s -- -y
command -v flyctl  >/dev/null 2>&1 || curl -L https://fly.io/install.sh | sh
command -v docker  >/dev/null 2>&1 || curl -fsSL https://get.docker.com | sh
command -v claude  >/dev/null 2>&1 || curl -fsSL https://claude.ai/install.sh | bash
command -v peon    >/dev/null 2>&1 || curl -fsSL https://raw.githubusercontent.com/PeonPing/peon-ping/main/install.sh | bash

if ! command -v aws >/dev/null 2>&1; then
  curl -sS "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
  unzip -qo /tmp/awscliv2.zip -d /tmp
  sudo /tmp/aws/install
  rm -rf /tmp/awscliv2.zip /tmp/aws
fi

# apt fzf predates `fzf --zsh` (needs 0.48+)
if ! command -v fzf >/dev/null 2>&1 || ! fzf --zsh >/dev/null 2>&1; then
  FZF_VERSION=0.56.3
  mkdir -p "$HOME/.local/bin"
  curl -fsSL "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz" |
    tar -xz -C "$HOME/.local/bin"
fi

if ! command -v just >/dev/null 2>&1; then
  mkdir -p "$HOME/.local/bin"
  curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to "$HOME/.local/bin"
fi

# apt neovim is capped below AstroNvim's floor (>=0.10)
if ! nvim --version 2>/dev/null | head -1 | grep -qE 'NVIM v0\.(1[0-9]|[2-9][0-9])'; then
  sudo apt-get remove -y neovim neovim-runtime 2>/dev/null || true
  NVIM_TARBALL_URL=$(curl -fsSL https://api.github.com/repos/neovim/neovim/releases/latest |
    jq -r '.assets[] | select(.name == "nvim-linux-x86_64.tar.gz") | .browser_download_url')
  curl -fsSL "$NVIM_TARBALL_URL" -o /tmp/nvim.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -xzf /tmp/nvim.tar.gz -C /opt
  sudo mv /opt/nvim-linux-x86_64 /opt/nvim
  sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
  rm /tmp/nvim.tar.gz
fi
{{ end -}}
```

- [ ] **Step 4: Verify templates render**

```bash
chezmoi execute-template < run_onchange_10-packages-darwin.sh.tmpl | head -5
SANDBOX=$(tests/sandbox-apply.sh)   # still succeeds; scripts are excluded
```

- [ ] **Step 5: Commit**

```bash
git add -A && git commit -m "chezmoi: package installers as run_onchange; pare linux to headless server set"
```

---

### Task 10: macOS WM — aerospace, karabiner, sketchybar, peon relay, defaults

**Files:**
- Create (moves): `dot_config/aerospace/aerospace.toml`, `dot_config/aerospace/scripts/executable_*.sh`, `dot_config/karabiner/karabiner.json`, `dot_config/sketchybar/**`, `Library/LaunchAgents/org.felixkratz.sketchybar.plist`
- Create (moves): `machine/darwin/aerospace-swipe/{install-swipe.sh,swipe-config.json}`, `machine/darwin/peon/{install-relay.sh,com.peon-ping.relay.plist}`
- Create: `run_onchange_20-darwin-services.sh.tmpl`, `run_onchange_30-darwin-defaults.sh.tmpl`
- Delete: `macos/karabiner/sync.sh`, `macos/scripts/update-karabiner.sh`, `macos/scripts/save-alttab.sh`, `macos/scripts/restore-alttab.sh`

**Interfaces:**
- Produces: aerospace config at XDG path `~/.config/aerospace/aerospace.toml` (replaces `~/.aerospace.toml`, removed at cutover); switcher scripts at `~/.config/aerospace/scripts/`.
- Consumes: `machine/darwin/Brewfile` (Task 9) installs aerospace/karabiner/sketchybar-font casks.

- [ ] **Step 1: Move aerospace to XDG layout and repoint script paths**

```bash
mkdir -p dot_config/aerospace
git mv macos/aerospace/aerospace.toml dot_config/aerospace/aerospace.toml
mkdir -p dot_config/aerospace/scripts
for s in enter-resize-if-floating toggle-float switcher switcher.test; do
  git mv "macos/aerospace/scripts/$s.sh" "dot_config/aerospace/scripts/executable_$s.sh"
done
mkdir -p machine/darwin/aerospace-swipe
git mv macos/aerospace/install-swipe.sh machine/darwin/aerospace-swipe/install-swipe.sh
git mv macos/aerospace/swipe-config.json machine/darwin/aerospace-swipe/swipe-config.json
```

In `dot_config/aerospace/aerospace.toml`, replace every `~/dotfiles/macos/aerospace/scripts/<name>.sh` with `~/.config/aerospace/scripts/<name>.sh` (lines 99 and 115 as of writing; grep to catch all):

```bash
grep -n 'dotfiles/macos' dot_config/aerospace/aerospace.toml   # expect no output after editing
```

In `machine/darwin/aerospace-swipe/install-swipe.sh`, find self-referencing paths (`grep -n 'dirname\|DOTFILES\|dotfiles' machine/darwin/aerospace-swipe/install-swipe.sh`) and fix any that assumed the old `macos/aerospace/` location (its `swipe-config.json` sibling reference survives the move as-is if it uses `dirname "$0"`).

The internal path in `dot_config/aerospace/scripts/executable_switcher.sh` and its test may also reference the old location — grep and repoint to `~/.config/aerospace/scripts/`:

```bash
grep -n 'dotfiles' dot_config/aerospace/scripts/executable_*.sh
```

Run the switcher's own test suite after the edits:

```bash
bash dot_config/aerospace/scripts/executable_switcher.test.sh
```

- [ ] **Step 2: Karabiner becomes a managed file; sync scripts retire**

```bash
mkdir -p dot_config/karabiner
git mv macos/karabiner/karabiner.json dot_config/karabiner/karabiner.json
git rm macos/karabiner/sync.sh macos/scripts/update-karabiner.sh
git rm macos/scripts/save-alttab.sh macos/scripts/restore-alttab.sh   # AltTab app retired for the karabiner switcher
```

In `dot_config/karabiner/karabiner.json`, replace the absolute switcher path `/Users/kylecoberly/dotfiles/macos/aerospace/scripts/switcher.sh` with `$HOME/.config/aerospace/scripts/switcher.sh` (karabiner runs `shell_command` via a shell, so `$HOME` expands). Verify:

```bash
grep -c 'dotfiles' dot_config/karabiner/karabiner.json   # expect 0
jq empty dot_config/karabiner/karabiner.json
```

Why no restart logic: Karabiner-Elements watches `karabiner.json` via FSEvents and auto-reloads; `chezmoi apply` replaces the old push-copy `sync.sh`. Device state (`devices`, `keyboard_type_v2`) that Karabiner writes into the live file is preserved by the sync script's `re-add`-before-apply flow (Task 11) and captured once manually at cutover (Task 13).

- [ ] **Step 3: Sketchybar — configs managed, plist managed, bootstrap script**

```bash
mkdir -p dot_config/sketchybar Library/LaunchAgents
git mv macos/sketchybar/sketchybarrc dot_config/sketchybar/executable_sketchybarrc
mkdir -p dot_config/sketchybar/plugins
for p in clock cpu focused_windows icon_map sound space; do
  git mv "macos/sketchybar/plugins/$p.sh" "dot_config/sketchybar/plugins/executable_$p.sh"
done
git mv macos/sketchybar/org.felixkratz.sketchybar.plist "Library/LaunchAgents/org.felixkratz.sketchybar.plist"
```

`sketchybarrc` and `plugins/space.sh` source `$HOME/dotfiles/theme/palette.sh` — that path is still valid (repo stays at `~/dotfiles`); leave those lines alone. Check the plist for repo paths:

```bash
grep -n 'dotfiles' "Library/LaunchAgents/org.felixkratz.sketchybar.plist" dot_config/sketchybar/executable_sketchybarrc dot_config/sketchybar/plugins/executable_*.sh
```

Any hit pointing at `~/dotfiles/macos/sketchybar/...` must become `~/.config/sketchybar/...`; hits on `~/dotfiles/theme/` stay.

- [ ] **Step 4: Peon relay files move; write the services script**

```bash
mkdir -p machine/darwin/peon
git mv macos/peon/install-relay.sh machine/darwin/peon/install-relay.sh
git mv macos/peon/com.peon-ping.relay.plist machine/darwin/peon/com.peon-ping.relay.plist
```

In `machine/darwin/peon/install-relay.sh`, update the plist path: it currently renders `"$DOTFILES/macos/peon/com.peon-ping.relay.plist"` — change to resolve the plist as a sibling: `"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/com.peon-ping.relay.plist"`, and delete the `DOTFILES=` default line if nothing else uses it.

Create `run_onchange_20-darwin-services.sh.tmpl`:

```bash
{{ if eq .chezmoi.os "darwin" -}}
#!/usr/bin/env bash
# Service wiring. Re-runs when the sketchybar plist or swipe/relay installers change:
# sketchybar plist hash: {{ include "Library/LaunchAgents/org.felixkratz.sketchybar.plist" | sha256sum }}
# swipe installer hash:  {{ include "machine/darwin/aerospace-swipe/install-swipe.sh" | sha256sum }}
# relay installer hash:  {{ include "machine/darwin/peon/install-relay.sh" | sha256sum }}
set -euo pipefail

# Sketchybar — build from source (v2.17+ needs a newer SDK than some Xcodes)
if ! command -v sketchybar >/dev/null 2>&1; then
  SB_BUILD="$(mktemp -d)"
  git clone --depth=1 --branch v2.16.4 https://github.com/FelixKratz/SketchyBar.git "$SB_BUILD/SketchyBar"
  (cd "$SB_BUILD/SketchyBar" && make)
  sudo cp "$SB_BUILD/SketchyBar/bin/sketchybar" /usr/local/bin/sketchybar
  sudo chmod +x /usr/local/bin/sketchybar
  rm -rf "$SB_BUILD"
fi
launchctl bootout "gui/$(id -u)/org.felixkratz.sketchybar" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/org.felixkratz.sketchybar.plist"

# Aerospace trackpad-swipe daemon (one-time Accessibility grant; script prints how)
"{{ .chezmoi.sourceDir }}/machine/darwin/aerospace-swipe/install-swipe.sh"

# Peon-ping relay LaunchAgent
if command -v peon >/dev/null 2>&1; then
  "{{ .chezmoi.sourceDir }}/machine/darwin/peon/install-relay.sh"
fi
{{ end -}}
```

- [ ] **Step 5: Write `run_onchange_30-darwin-defaults.sh.tmpl`** (verbatim from the old `macos/install.sh` defaults block)

```bash
{{ if eq .chezmoi.os "darwin" -}}
#!/usr/bin/env bash
set -euo pipefail
defaults write com.apple.dock no-bouncing -bool true
defaults write com.apple.dock expose-group-apps -bool true
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g NSWindowResizeTime -float 0.001
defaults write com.apple.Finder AppleShowAllFiles -bool true
# Disable native 3-finger horizontal Spaces swipe — fights aerospace-swipe
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
killall Dock 2>/dev/null || true
{{ end -}}
```

- [ ] **Step 6: Verify via sandbox and clean up empty dirs**

```bash
SANDBOX=$(tests/sandbox-apply.sh)
test -f "$SANDBOX/.config/aerospace/aerospace.toml" \
  && test -x "$SANDBOX/.config/aerospace/scripts/switcher.sh" \
  && test -f "$SANDBOX/.config/karabiner/karabiner.json" \
  && test -x "$SANDBOX/.config/sketchybar/sketchybarrc" \
  && test -f "$SANDBOX/Library/LaunchAgents/org.felixkratz.sketchybar.plist" && echo OK
find macos linux shared -type f 2>/dev/null   # expect: nothing (remove any straggler dirs)
rmdir -p macos/* macos linux shared 2>/dev/null || true
```

- [ ] **Step 7: Commit**

```bash
git add -A && git commit -m "chezmoi: port aerospace/karabiner/sketchybar/peon; retire push-sync scripts"
```

---

### Task 11: Sync automation — chezmoi-sync script, launchd, systemd

**Files:**
- Create: `dot_local/bin/executable_chezmoi-sync`
- Create: `Library/LaunchAgents/com.kylecoberly.chezmoi-sync.plist`
- Create: `dot_config/systemd/user/chezmoi-sync.service`, `dot_config/systemd/user/chezmoi-sync.timer`
- Create: `run_onchange_40-sync-timer-linux.sh.tmpl`, addition to `run_onchange_20-darwin-services.sh.tmpl`

**Interfaces:**
- Consumes: statusline warning file contract from Task 8: `~/.cache/chezmoi-sync/last-error`.
- Produces: `chezmoi-sync` on PATH; runs every 30 min on both platforms.

- [ ] **Step 1: Write `dot_local/bin/executable_chezmoi-sync`**

```bash
#!/usr/bin/env bash
# Periodic sync: capture runtime-mutated files, pull+apply, push.
# On failure: stop and surface (statusline shows ⚠ sync) — never force.
set -uo pipefail

STATE_DIR="$HOME/.cache/chezmoi-sync"
mkdir -p "$STATE_DIR"
ERR_FILE="$STATE_DIR/last-error"

fail() {
  printf '%s\n%s\n' "$(date -Iseconds)" "$1" > "$ERR_FILE"
  exit 1
}

command -v chezmoi >/dev/null 2>&1 || fail "chezmoi not on PATH"

# Files that tools rewrite at runtime; live copy wins, repo captures it.
# (autoCommit/autoPush in chezmoi config commit+push each re-add.)
MUTATED=(
  "$HOME/.claude/settings.json"
  "$HOME/.claude/CLAUDE.md"
  "$HOME/.config/karabiner/karabiner.json"
)
for f in "${MUTATED[@]}"; do
  [ -f "$f" ] && chezmoi re-add "$f" || true
done

chezmoi update --apply || fail "chezmoi update (pull+apply) failed"
chezmoi git -- push --quiet || fail "git push failed"

rm -f "$ERR_FILE"
```

- [ ] **Step 2: Write `Library/LaunchAgents/com.kylecoberly.chezmoi-sync.plist`**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.kylecoberly.chezmoi-sync</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>-lc</string>
    <string>"$HOME/.local/bin/chezmoi-sync"</string>
  </array>
  <key>StartInterval</key><integer>1800</integer>
  <key>StandardErrorPath</key><string>/tmp/chezmoi-sync.err</string>
</dict>
</plist>
```

Add to the end of `run_onchange_20-darwin-services.sh.tmpl` (inside the darwin guard), plus its hash comment near the top:

```bash
# chezmoi-sync plist hash: {{ include "Library/LaunchAgents/com.kylecoberly.chezmoi-sync.plist" | sha256sum }}
launchctl bootout "gui/$(id -u)/com.kylecoberly.chezmoi-sync" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.kylecoberly.chezmoi-sync.plist"
```

- [ ] **Step 3: Write the systemd user units**

`dot_config/systemd/user/chezmoi-sync.service`:

```ini
[Unit]
Description=chezmoi periodic sync

[Service]
Type=oneshot
ExecStart=/bin/bash -lc "$HOME/.local/bin/chezmoi-sync"
```

`dot_config/systemd/user/chezmoi-sync.timer`:

```ini
[Unit]
Description=Run chezmoi-sync every 30 minutes

[Timer]
OnBootSec=5min
OnUnitActiveSec=30min

[Install]
WantedBy=timers.target
```

`run_onchange_40-sync-timer-linux.sh.tmpl`:

```bash
{{ if eq .chezmoi.os "linux" -}}
#!/usr/bin/env bash
# timer hash: {{ include "dot_config/systemd/user/chezmoi-sync.timer" | sha256sum }}
set -euo pipefail
systemctl --user daemon-reload
systemctl --user enable --now chezmoi-sync.timer
{{ end -}}
```

- [ ] **Step 4: Verify script logic by hand (no timers yet — repo isn't live)**

```bash
SANDBOX=$(tests/sandbox-apply.sh)
test -x "$SANDBOX/.local/bin/chezmoi-sync" && echo OK
bash -n dot_local/bin/executable_chezmoi-sync
plutil -lint Library/LaunchAgents/com.kylecoberly.chezmoi-sync.plist
```

- [ ] **Step 5: Commit**

```bash
git add -A && git commit -m "chezmoi: periodic sync script with launchd/systemd timers"
```

---

### Task 12: README rewrite and final source-tree sweep

**Files:**
- Modify: `README.md`, `.gitignore`

**Interfaces:**
- Produces: a README documenting bootstrap, layout, theme flow, sync model, and plan/artifact routing.

- [ ] **Step 1: Confirm nothing from the old layout remains**

```bash
git ls-files | grep -E '^(shared|macos|linux)/' && echo "LEFTOVERS — move or delete them" || echo CLEAN
grep -rn 'shared/\|macos/\|linux/' --include='*.sh' --include='*.toml' --include='*.md' --exclude-dir=.git --exclude-dir=docs . | grep -v 'docs/superpowers' || echo NO-STALE-REFS
```

- [ ] **Step 2: Update `.gitignore`** — remove the `shared/claude/skills/peon-ping-*/` and `plugins` entries (their directories are gone); keep `.DS_Store`, `*.swp`, `*~`, `theme/palette.sh.bak`, `tmux-client-*.log`.

- [ ] **Step 3: Rewrite `README.md`**

```markdown
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
- `.chezmoiexternal.toml` — zsh + tmux plugins, cloned/refreshed by chezmoi
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
  Sync is their transport, not git.

## History

Pre-chezmoi symlink layout is preserved on the `legacy` branch.
```

- [ ] **Step 4: Commit**

```bash
git add -A && git commit -m "docs: README for the chezmoi layout and sync model"
```

---

### Task 13: Mac cutover

**Files:** none new — this task applies the branch to the live machine.

**Interfaces:**
- Consumes: everything above; runs on the MacBook with the `chezmoi` branch checked out at `~/dotfiles`.

- [ ] **Step 1: Full test suite + dry-run diff**

```bash
bash tests/run.sh
chezmoi init --source "$HOME/dotfiles"        # renders ~/.config/chezmoi/chezmoi.toml from the template
chezmoi doctor                                # no errors (warnings about optional tools are fine)
chezmoi diff | less                           # review: expect creations/replacements matching the port, nothing surprising
```

- [ ] **Step 2: Capture karabiner device state into the source before first apply**

Karabiner writes `devices` and `virtual_hid_keyboard.keyboard_type_v2` into the live config; clobbering them re-triggers the "identify keyboard" prompt. Merge live state into the managed copy:

```bash
python3 - <<'PY'
import json
src = "dot_config/karabiner/karabiner.json"
live = json.load(open(__import__("os").path.expanduser("~/.config/karabiner/karabiner.json")))
managed = json.load(open(src))
lp, mp = live["profiles"][0], managed["profiles"][0]
if lp.get("devices"): mp["devices"] = lp["devices"]
lk = lp.get("virtual_hid_keyboard", {}).get("keyboard_type_v2")
if lk: mp.setdefault("virtual_hid_keyboard", {})["keyboard_type_v2"] = lk
json.dump(managed, open(src, "w"), indent=4)
PY
git add dot_config/karabiner/karabiner.json && git commit -m "karabiner: capture live device state before cutover"
```

- [ ] **Step 3: Preserve peon-ping skills, then remove the old symlinks**

```bash
# peon-ping's installer-owned skill dirs live behind the skills symlink — rescue first
mkdir -p /tmp/claude-skills-rescue
cp -R ~/dotfiles/shared/claude/skills/peon-ping-* /tmp/claude-skills-rescue/ 2>/dev/null || true

for l in ~/.zshrc ~/.gitconfig ~/.gitignore ~/.asdfrc ~/.tool-versions ~/.aerospace.toml \
         ~/.config/starship.toml ~/.config/tmux ~/.config/nvim ~/.config/alacritty/alacritty.toml \
         ~/.config/sketchybar ~/Library/LaunchAgents/org.felixkratz.sketchybar.plist \
         ~/.claude/settings.json ~/.claude/CLAUDE.md ~/.claude/statusline-command.sh \
         ~/.claude/commands ~/.claude/agents ~/.claude/skills ~/.claude/hooks/save-plan \
         ~/.claude/hooks/peon-ping/config.json; do
  [ -L "$l" ] && rm "$l" && echo "removed symlink $l"
done

mkdir -p ~/.claude/skills
cp -R /tmp/claude-skills-rescue/peon-ping-* ~/.claude/skills/ 2>/dev/null || true
```

(Note `~/.aerospace.toml` must be gone — AeroSpace prefers it over the XDG path.)

- [ ] **Step 4: Apply for real**

```bash
chezmoi apply -v
```

Watch the run_ scripts: brew bundle should be a fast no-op (everything installed), launchd bootstraps should succeed, defaults are idempotent.

- [ ] **Step 5: Smoke checklist** (each item verified, not assumed)

```bash
zsh -ic 'echo $OBSIDIAN_VAULT && alias | head -3'        # zshrc + aliases load
git config user.name                                      # gitconfig applied
tmux new-session -d -s smoketest && tmux kill-session -t smoketest
nvim --headless "+Lazy! home" +qa 2>&1 | tail -2          # nvim boots
aerospace list-workspaces --all                           # aerospace running with XDG config
launchctl print "gui/$(id -u)/org.felixkratz.sketchybar" | head -3
launchctl print "gui/$(id -u)/com.kylecoberly.chezmoi-sync" | head -3
ls ~/.config/tmux/plugins ~/.zsh/plugins                  # externals cloned
~/.claude/scripts/vault-target.sh                         # prints vault + account + project
chezmoi-sync && echo SYNC-OK                              # full sync cycle passes
```

Also verify interactively: karabiner alt-tab switcher works (no "identify keyboard" prompt appeared), a Claude session shows the statusline, and `ExitPlanMode` on a scratch plan writes into `~/Documents/notes/zz_/plans/<account>/dotfiles/`.

- [ ] **Step 6: Commit any fixups from the smoke test** (each as its own focused commit on `chezmoi`).

---

### Task 14: Rebranch, push, Serena bootstrap

**Files:** none — git surgery and remote-machine bootstrap.

- [ ] **Step 1: Preserve old master as `legacy`, fast-forward master**

The `chezmoi` branch was built on top of `master`, so this is a fast-forward — no force anywhere:

```bash
git checkout master
git branch legacy                 # legacy = old master tip
git merge --ff-only chezmoi
git push origin legacy master
git branch -d chezmoi
```

- [ ] **Step 2: Serena bootstrap (over SSH)**

```bash
ssh serena
mv ~/dotfiles ~/dotfiles.pre-chezmoi          # keep the old checkout until verified
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --source ~/dotfiles --apply git@github.com:kylecoberly/dotfiles.git
```

- [ ] **Step 3: Serena smoke checklist**

```bash
zsh -ic 'echo $OBSIDIAN_VAULT'                          # expect /mnt/files/application-data/obsidian/notes
ls ~/.config/aerospace ~/.config/karabiner 2>&1          # expect: No such file (mac-only excluded)
systemctl --user list-timers | grep chezmoi-sync
~/.claude/scripts/vault-target.sh                        # vault resolves to /mnt/files path
bash ~/dotfiles/tests/run.sh
chezmoi-sync && echo SYNC-OK
```

Then run a scratch Claude plan-mode session on Serena and confirm the plan file appears in Obsidian on the Mac (vault synced by the desktop emulator).

- [ ] **Step 4: Clean up**

```bash
# on Serena, once everything checks out:
rm -rf ~/dotfiles.pre-chezmoi
# on the Mac:
rm -rf ~/.dotfiles-backup /tmp/claude-skills-rescue
```

- [ ] **Step 5: Final commit/push of any Serena-discovered fixups** (normal commits to master, pushed; Serena picks them up via `chezmoi-sync`).
