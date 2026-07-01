#!/usr/bin/env bash
# common.sh — shared helpers for the practice runner and task graders.
#
# Graders source this (via a relative path header) and then call:
#   check      "description"  cmd args...      # pass if cmd exits 0
#   check_eval "description" 'shell string'    # pass if the string evals 0 (pipes/globs ok)
#   grade_summary                              # prints PASS/FAIL, sets exit status
#
# It also exposes spare_disk() for storage tasks.

# ----- colours (disabled when not a terminal) --------------------------------
if [ -t 1 ]; then
  C_G=$'\033[32m'; C_R=$'\033[31m'; C_Y=$'\033[33m'; C_B=$'\033[34m'
  C_BOLD=$'\033[1m'; C_DIM=$'\033[2m'; C_0=$'\033[0m'
else
  C_G=; C_R=; C_Y=; C_B=; C_BOLD=; C_DIM=; C_0=
fi

# ----- grading ---------------------------------------------------------------
_PASS=0; _FAIL=0

check() {
  local desc="$1"; shift
  if "$@" >/dev/null 2>&1; then
    printf "  ${C_G}✓${C_0} %s\n" "$desc"; _PASS=$((_PASS + 1))
  else
    printf "  ${C_R}✗${C_0} %s\n" "$desc"; _FAIL=$((_FAIL + 1))
  fi
}

check_eval() {
  local desc="$1" expr="$2"
  if eval "$expr" >/dev/null 2>&1; then
    printf "  ${C_G}✓${C_0} %s\n" "$desc"; _PASS=$((_PASS + 1))
  else
    printf "  ${C_R}✗${C_0} %s\n" "$desc"; _FAIL=$((_FAIL + 1))
  fi
}

grade_summary() {
  local total=$((_PASS + _FAIL))
  echo
  if [ "$_FAIL" -eq 0 ] && [ "$total" -gt 0 ]; then
    printf "${C_G}${C_BOLD}PASS${C_0} — %d/%d checks passed\n" "$_PASS" "$total"
    return 0
  fi
  printf "${C_R}${C_BOLD}FAIL${C_0} — %d/%d checks passed\n" "$_PASS" "$total"
  return 1
}

# ----- storage helpers -------------------------------------------------------
# Print the block device to use as the "spare" disk for storage tasks.
# Override with SPARE_DISK=/dev/xyz. Defaults to the first likely spare.
spare_disk() {
  if [ -n "${SPARE_DISK:-}" ]; then echo "$SPARE_DISK"; return 0; fi
  local d
  for d in /dev/vdb /dev/sdb /dev/vdc /dev/sdc; do
    [ -b "$d" ] && { echo "$d"; return 0; }
  done
  return 1
}

# True if it's safe to wipe $1: it's a real disk, not the root disk, nothing mounted on it.
spare_is_safe() {
  local d="$1" rootsrc rootdisk
  [ -b "$d" ] || return 1
  rootsrc=$(findmnt -no SOURCE / 2>/dev/null)
  rootdisk="/dev/$(lsblk -no PKNAME "$rootsrc" 2>/dev/null | head -1)"
  [ "$d" = "$rootdisk" ] && return 1
  lsblk -no MOUNTPOINT "$d" 2>/dev/null | grep -q . && return 1
  return 0
}

# Destroy any LVM/partitions/signatures on the spare disk so a task starts clean.
wipe_spare() {
  local d="$1"
  spare_is_safe "$d" || { echo "refusing to wipe '$d' (root disk or mounted)"; return 1; }
  local part
  # tear down LVM that sits on this disk or its partitions
  for part in "$d" "$d"[0-9]*; do
    [ -b "$part" ] || continue
    local vg
    vg=$(pvs --noheadings -o vg_name "$part" 2>/dev/null | tr -d ' ')
    [ -n "$vg" ] && vgremove -f "$vg" >/dev/null 2>&1
    pvremove -ff -y "$part" >/dev/null 2>&1
  done
  swapoff "$d"[0-9]* 2>/dev/null
  wipefs -a "$d" >/dev/null 2>&1
  # remove any partition table
  sgdisk --zap-all "$d" >/dev/null 2>&1 || dd if=/dev/zero of="$d" bs=1M count=10 >/dev/null 2>&1
  partprobe "$d" >/dev/null 2>&1
  return 0
}
