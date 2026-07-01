#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

if ! command -v grubby >/dev/null 2>&1; then
  printf "  ${C_Y}note${C_0} grubby is not installed — cannot verify per-kernel boot arguments.\n"
fi

# 1. The default (running-config) kernel must carry rd.md=0.
check_eval "default kernel has rd.md=0 (grubby)" \
  'grubby --info=DEFAULT 2>/dev/null | grep -Eq "^args=.*(^|[\" ])rd\.md=0([\" ]|$)"'

# 2. Every installed kernel entry should carry it (persists to the next boot).
#    Fail if any 'args=' line is missing rd.md=0.
check_eval "all installed kernels have rd.md=0" \
  '! grubby --info=ALL 2>/dev/null | grep -E "^args=" | grep -qvE "(^|[\" ])rd\.md=0([\" ]|$)"'

# 3. /etc/default/grub carries it so future kernels inherit it.
check_eval "/etc/default/grub GRUB_CMDLINE_LINUX has rd.md=0" \
  'grep -E "^GRUB_CMDLINE_LINUX=" /etc/default/grub 2>/dev/null | grep -Eq "(^|[\" ])rd\.md=0([\" ]|$)"'

grade_summary
