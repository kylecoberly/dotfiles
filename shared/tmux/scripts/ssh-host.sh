#!/usr/bin/env bash
# Print " <hostname>" when inside an ssh session, otherwise nothing.
# SSH_TTY / SSH_CONNECTION are set by sshd for the login shell and
# inherited by panes spawned under it.

set -u

if [[ -n "${SSH_TTY:-}" || -n "${SSH_CONNECTION:-}" ]]; then
  # Leading char is U+F233 (nerd-fonts fa-server glyph)
  printf ' \xef\x88\xb3 %s' "$(hostname -s)"
fi
