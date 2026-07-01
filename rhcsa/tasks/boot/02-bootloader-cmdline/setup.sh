#!/usr/bin/env bash
# Clean slate: strip any pre-existing rd.md=0 argument so there is work to do.

# Remove from every installed kernel entry (best-effort).
if command -v grubby >/dev/null 2>&1; then
  grubby --update-kernel=ALL --remove-args="rd.md=0" 2>/dev/null || true
fi

# Remove from /etc/default/grub GRUB_CMDLINE_LINUX.
if [ -f /etc/default/grub ]; then
  sed -i 's/[[:space:]]*rd\.md=0//g' /etc/default/grub 2>/dev/null
fi

exit 0
