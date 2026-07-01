#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "/root/logs.tar.gz exists"              '[ -f /root/logs.tar.gz ]'
check_eval "file is gzip-compressed data"          'file -b /root/logs.tar.gz | grep -qi gzip'
check_eval "it is a valid tar archive (lists ok)"  'tar -tzf /root/logs.tar.gz'
check_eval "archive contains the logs directory"   'tar -tzf /root/logs.tar.gz 2>/dev/null | grep -Eq "(^|/)opt/logs/?$|(^|/)opt/logs/"'
check_eval "archive contains auth.log"             'tar -tzf /root/logs.tar.gz 2>/dev/null | grep -q "auth.log"'
check_eval "archive contains kern.log"             'tar -tzf /root/logs.tar.gz 2>/dev/null | grep -q "kern.log"'

grade_summary
