#!/usr/bin/env bash
# Reference solution.

# Apply to every currently installed kernel.
grubby --update-kernel=ALL --args="rd.md=0"

# Ensure future kernels inherit it too.
if grep -q '^GRUB_CMDLINE_LINUX=' /etc/default/grub; then
  # Append inside the existing quoted value if not already present.
  grep -Eq '(^|[" ])rd\.md=0([" ]|$)' <(grep '^GRUB_CMDLINE_LINUX=' /etc/default/grub) \
    || sed -i 's/^\(GRUB_CMDLINE_LINUX="[^"]*\)"/\1 rd.md=0"/' /etc/default/grub
else
  echo 'GRUB_CMDLINE_LINUX="rd.md=0"' >> /etc/default/grub
fi
