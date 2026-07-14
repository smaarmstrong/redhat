# Task format

Every practice task is a directory under `tasks/<domain>/<NN-name>/` containing
five required files plus one optional lesson. The `practice` runner discovers
tasks by scanning for `meta.json`.

```
tasks/storage/01-lvm-filesystem/
├── meta.json      # metadata (parsed by the runner)
├── prompt.md      # the task shown to the learner
├── setup.sh       # establishes the starting state (runs as root)
├── grade.sh       # checks the end state (runs as root)
├── solution.sh    # a reference solution (revealed on request)
└── learn.md       # OPTIONAL: the lesson shown by `practice learn` (see below)
```

## `meta.json`

```json
{
  "title": "Create an LVM filesystem, mounted persistently",
  "domain": "Storage",
  "objective": "Configure systems to mount file systems at boot by UUID or label",
  "est_min": 10,
  "needs": "spare-disk"
}
```

- `objective` should quote the wording from [rhcsa-objectives.md](rhcsa-objectives.md).
- `needs` is `""` normally, or `"spare-disk"` for tasks that require a blank disk.

## `prompt.md`

Plain text shown to the learner: exactly what's required, and — where relevant —
that the configuration **must persist across a reboot** (the guiding rule of the
real exam).

## `setup.sh`

Runs as root before the learner starts. Must be **idempotent** and establish a
clean starting state (remove leftovers from a previous attempt; create any
prerequisites; for a "fix it" task, break something on purpose). End with `exit 0`.

## `grade.sh`

Runs as root. Must begin with this exact header so it can use the shared helpers:

```bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"
```

Then assert requirements and finish with `grade_summary`:

```bash
check      "user 'dbuser' exists"  getent passwd dbuser      # pass if the command exits 0
check_eval "UID is 1500" '[ "$(id -u dbuser)" = 1500 ]'      # eval a string (pipes/$vars OK)
grade_summary                                                # prints PASS/FAIL, sets exit status
```

**Grade the end state, never the commands typed** — any valid path to the correct
outcome must pass. **Check persistence**, not just the running state: `/etc/fstab`
by UUID, `systemctl is-enabled`, `firewall-cmd --permanent`, `/etc/shadow` fields,
`semanage` for SELinux, etc.

Helpers available from `common.sh`: `check`, `check_eval`, `grade_summary`,
`spare_disk`, `spare_is_safe`, `wipe_spare`, and colour vars (`C_G`, `C_R`, `C_Y`, `C_0`).

## `solution.sh`

A minimal reference solution (one valid path). Storage tasks may start with the
same `common.sh` header to use `spare_disk()`. The runner hides the header lines
when displaying it.

## `learn.md` (optional)

The tutorial shown by `practice learn` before the learner attempts the task —
for people meeting the material for the first time, not just being tested on it.
Optional: if it's absent, `learn` falls back to showing the prompt and pointing
at `solution`. It's printed as-is to the terminal, so write plain, readable text
(light structure, `$ command` lines) rather than heavy Markdown. Keep it to the
concept, not a command dump. The house style is five short sections:

```
THE IDEA        what the thing is and the mental model for it
WHY IT MATTERS  why the exam and a real admin care
HOW TO DO IT    the actual commands, explained (not just pasted)
CHECK IT WORKED how to confirm it — ideally what the grader looks at
GOTCHAS         the classic traps (e.g. "persist across reboot", two-places edits)
```

A good `learn.md` teaches the *skill* so the solution becomes obvious; it should
never be just a reworded `solution.sh`.

## Authoring rules

- Use only tools present in a **Rocky 9 base install** (no internet assumed). If a
  task needs an extra package, have `setup.sh` best-effort install it and have
  `grade.sh` degrade gracefully if it's absent.
- Never touch the root disk in storage tasks — use `spare_disk()`/`wipe_spare()`,
  which refuse to act on anything mounted or on the root device.
- Syntax-check everything (`bash -n`, `python3 -m json.tool`) — but only ever
  **run** setup/grade/solution inside a throwaway practice machine, never on a host.
