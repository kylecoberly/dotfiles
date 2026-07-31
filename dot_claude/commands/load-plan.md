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
