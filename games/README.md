# games — the console practice engine

`practice` is a terminal trainer for the RHCSA objectives. It runs **inside the
Rocky practice machine**: each task gives you a real, exam-shaped job to do on the
system, then grades the **end state** (the way the real exam is scored) — not the
commands you typed.

## Just want to practise? (the zero-decision loop)

If you don't want to think about *what* to do, don't. From the repo root:

```bash
make train     # picks the next task for you (new material, or a review), and sets it up
#   ...do the task on the system...
make check     # grade it, then `make train` again for the next one
```

`train` decides on its own whether to teach you something **new** (the next task
in sequence) or bring back **older** material you've passed before, on a
spaced-repetition schedule — items you got right come back at widening intervals
(1, 3, 7, 16, 35, 75 days…), and anything you fail comes back quickly. Reviews
take priority once they're due, but it never gives you more than two in a row
while new tasks are still waiting, so you always keep moving forward. `make` just
forwards to `./games/practice` — the runner below is the real thing.

## The full command surface (inside the Rocky VM/machine)

```bash
git clone https://github.com/smaarmstrong/redhat ~/redhat
cd ~/redhat

./games/practice train               # auto-pick what to do next, and set it up
./games/practice check               # grade the task you're currently on
./games/practice list                # all tasks, grouped by domain, with your status
./games/practice start create-user   # show a specific task and set up its starting state
./games/practice check create-user   # grade a specific task — pass/fail per requirement
./games/practice solution create-user   # reveal a reference solution
./games/practice reset  create-user  # start the task over
./games/practice status              # your XP, streak, completion
```

An `<id>` can be the full `domain/nn-name` or just the unique trailing name. For
`check`, `solution` and `reset` you can drop the `<id>` to act on whatever task
`train`/`start` last gave you.

Setup and grading change the system, so they run as root (via `sudo` if you aren't
already). Progress/XP/streak are stored in `~/.local/state/rhcsa-trainer/progress.json`.

## How it fits together

- `practice` — the Python 3 runner (discovery, prompts, grading, progress). Python 3
  ships in the Rocky base OS.
- `lib/common.sh` — Bash helpers every grader sources: `check`, `check_eval`,
  `grade_summary`, and storage helpers `spare_disk` / `wipe_spare` / `spare_is_safe`.
- `../rhcsa/tasks/<domain>/<nn-name>/` — the task content (see
  [../rhcsa/docs/TASK-FORMAT.md](../rhcsa/docs/TASK-FORMAT.md)).
- `selftest.sh` — run-verifies graders in throwaway Rocky 9 containers
  (`setup → grade [expect fail] → solution → grade [expect pass]`). Great for CI on
  the container-safe tasks; storage/systemd/firewall/SELinux tasks still need the VM.

## Note

The task scripts modify the system on purpose (create users, partition the spare
disk, edit `/etc/fstab`, set SELinux/firewall state, …). **Only run them in a
throwaway practice machine**, never on a host you care about.
