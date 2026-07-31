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
       # include a description line only when one was given
       printf 'description: %s\n' "<description>"
       printf -- '---\n\n'
       cat "$SRC"
     } > "$DEST_DIR/$BASE"
   else
     cp "$SRC" "$DEST_DIR/$BASE"
   fi
   ```
   If `$DEST_DIR/$BASE` already exists, append `-2`, `-3`, … before the extension rather than overwriting.

4. Report the final vault path to the user.
