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

## Communication
- Be terse. Skip trailing summaries of what you just did — the diff is visible.
- State results and decisions directly; don't narrate deliberation.
