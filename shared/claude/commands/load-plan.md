---
description: Load a previously saved plan from the Obsidian vault for the current context
argument-hint: [optional search hint]
---

Load a relevant saved plan from `$OBSIDIAN_VAULT/zz_plans/`.

## Steps

1. Determine the current context subfolder the same way the save-plan hook does:
   - If inside a git repo: `basename` of the repo root
   - If `pwd` is exactly `/Users/kylecoberly` or `/home/kylecoberly`: `home`
   - Otherwise: `basename` of `pwd`

2. List candidates in that subfolder:
   ```bash
   ls -1t "$OBSIDIAN_VAULT/zz_plans/<subfolder>/" 2>/dev/null
   ```
   (Newest first — filenames are timestamp-prefixed so `-t` and lexical sort agree.)

3. If `$ARGUMENTS` is non-empty, filter the list to filenames or contents matching the hint (use `rg` against the directory).

4. If exactly one plan matches, Read it and summarize for the user. If multiple match, list them with one-line summaries (first heading from each file) and ask which to load. If none match, say so and offer to list the full directory.

5. Once a plan is chosen, Read it and treat it as established context for the session.

Argument (optional search hint): $ARGUMENTS
