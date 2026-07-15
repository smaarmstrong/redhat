#!/usr/bin/env bash
#
# selftest.sh — run-verify task graders in throwaway Rocky 9 containers.
#
# For each task it runs, in a fresh container:
#   setup.sh  ->  grade.sh (expect FAIL)  ->  solution.sh  ->  grade.sh (expect PASS)
# That catches BOTH failure modes:
#   - a grader that passes before you've done anything (too lax / pre-satisfied)
#   - a grader that fails after a correct solution (too strict / wrong)
#
# A plain container has no systemd/loop-devices/full-SELinux, so only tasks that
# don't need those are checked here (see LIST below, or pass task ids as args).
# Storage/systemd/firewall/SELinux/container tasks must be verified in the real VM.
#
# Usage:  ./games/selftest.sh              # run the default container-safe set
#         ./games/selftest.sh tools/03-redirection permissions/01-collab-dir
#
# Task ids may be track-qualified ("foundations/text/03-sed-substitute");
# a bare "domain/task" id defaults to the rhcsa track.
#
set -uo pipefail
REPO="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)"
IMAGE="${IMAGE:-rockylinux:9}"

LIST=(
  foundations/editor/01-vim-basics foundations/shell/01-pipes-redirection
  foundations/text/01-grep-basics foundations/text/02-regex-basics
  foundations/text/03-sed-substitute foundations/text/04-awk-fields
  foundations/search/01-find-basics
  tools/01-links tools/02-tar-archive tools/03-redirection tools/04-grep-regex
  tools/05-file-management tools/06-find-files tools/07-text-file
  scripting/01-conditional scripting/02-loop
  users-groups/01-create-user users-groups/02-modify-user
  users-groups/03-groups-membership users-groups/04-password-aging
  users-groups/05-sudo-access
  permissions/01-collab-dir permissions/02-sticky-shared
  permissions/03-fix-permissions permissions/04-acl
  security/01-umask networking/02-hosts-entry software/01-configure-repo
)
[ "$#" -gt 0 ] && LIST=("$@")

pass=0; fail=0; failed=()
for id in "${LIST[@]}"; do
  case "$id" in
    */*/*) tp="${id%%/*}/tasks/${id#*/}" ;;   # track-qualified id
    *)     tp="rhcsa/tasks/$id" ;;            # bare id = rhcsa track
  esac
  out=$(docker run --rm -v "$REPO":/redhat:ro "$IMAGE" bash -c '
    set -u
    T=/redhat/'"$tp"'
    bash "$T/setup.sh" >/dev/null 2>&1
    if bash "$T/grade.sh" >/dev/null 2>&1; then echo "NEG=pass"; else echo "NEG=fail"; fi
    bash "$T/solution.sh" >/dev/null 2>&1
    if bash "$T/grade.sh" >/tmp/g 2>&1; then echo "POS=pass"; else echo "POS=fail"; fi
    tail -n +1 /tmp/g > /tmp/glog; cat /tmp/glog
  ' 2>&1)
  neg=$(grep -o 'NEG=[a-z]*' <<<"$out"); pos=$(grep -o 'POS=[a-z]*' <<<"$out")
  # Want: NEG=fail (grader fails before solution) and POS=pass (passes after).
  if [ "$neg" = "NEG=fail" ] && [ "$pos" = "POS=pass" ]; then
    printf "  \033[32m✓\033[0m %s\n" "$id"; pass=$((pass+1))
  else
    printf "  \033[31m✗\033[0m %-38s (%s %s)\n" "$id" "$neg" "$pos"; fail=$((fail+1)); failed+=("$id")
    if [ "${VERBOSE:-0}" = 1 ]; then sed 's/^/      /' <<<"$out" | grep -vE 'NEG=|POS=' | tail -8; fi
  fi
done
echo "----"
echo "verified: $pass   problems: $fail"
[ "$fail" -gt 0 ] && { echo "failed: ${failed[*]}"; exit 1; } || exit 0
