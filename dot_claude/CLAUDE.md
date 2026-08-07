# Personal Coding Preferences

These apply across all projects. Project-level `CLAUDE.md` files extend or override these.

## Style
- Prefer clarity over cleverness.
- Don't add comments that explain *what* — only *why* when non-obvious.
- Don't add error handling, fallbacks, or validation for cases that can't happen.
- Don't build abstractions for hypothetical future needs. Three similar lines beats a premature abstraction.

## Git
- Create new commits rather than amending.
- Never `--no-verify`, `--force`, or `reset --hard` without asking.
- Commit messages: focus on *why*, not *what*.

## Plans & Specs
- Superpowers design specs and implementation plans go to the Obsidian
  vault, not the repo. Resolve the target directory with:
  `read -r VAULT ACCOUNT PROJECT <<< "$(~/.claude/scripts/vault-target.sh)"`
  and save to `$VAULT/zz_/plans/$ACCOUNT/$PROJECT/` using the skill's
  normal filename (e.g. `YYYY-MM-DD-<topic>-design.md`).
- Skip the "commit the document to git" steps in those skills — the vault
  syncs via Obsidian Sync, and plan documents don't belong in project repos.
- If `vault-target.sh` exits non-zero (no vault on this machine), fall back
  to the skill's default in-repo location.

## Communication
- Be terse. Skip trailing summaries of what you just did — the diff is visible.
- State results and decisions directly; don't narrate deliberation.
