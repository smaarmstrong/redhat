# redhat

A terminal-native, gamified trainer for the **RHCSA** (and later **RHCE**) exams.

Instead of flashcards, you practice on a **real Rocky Linux 9 VM** — graded the way
the actual exam is graded: by checking the *end state* of the system, never by
matching the commands you typed.

## The idea

The real Red Hat exams are **performance-based** — you're dropped onto live systems
and judged on whether the task actually works. So this trainer is built around the
same loop:

```
pick a task  →  do it on a real Rocky 9 box  →  grade the end state  →  pass/fail  →  retry
```

Over time this grows the things that make practice sticky — a prerequisite skill
graph (atomic skills → composite exam-shaped scenarios), spaced repetition, and a
daily streak. But the foundation is the task → grade → retry loop on real infra.

## Design decisions

- **Guest OS:** Rocky Linux 9 — a bug-for-bug RHEL 9 rebuild, so it matches what
  the current RHCSA (EX200) actually tests.
- **Console-only.** No web app. Everything runs in a terminal, so it works over
  plain SSH and mirrors the exam environment.
- **The games run *inside* the Rocky VM.** This keeps them portable: the host
  laptop (Fedora today, a Mac later) doesn't matter, because the guest is identical
  either way.
- **The setup script is the exception** — it runs on the *host* to build the VM,
  because the VM can't build itself. It's the only host-specific piece.
- **Grading checks end state, not commands.** Any valid path to the right outcome
  passes — exactly like the real exam.

## Layout

```
redhat/
├── setup/       # runs on the HOST (Fedora/Mac) to build the Rocky 9 VM
├── games/       # shared console engine (practice runner + grading lib) — run in the VM
├── foundations/ # foundations track — teaches the shell tools the exam tasks assume
├── rhcsa/       # RHCSA track — tasks/ (graded Bash tasks) + docs/ (objectives, format)
├── rhce/        # RHCE track  — tasks/ (Ansible tasks) + docs/ (objectives, format)
└── README.md
```

The trainer covers **two exams**, plus the groundwork for them:

- **Foundations** — `foundations/tasks/`: first-class interactive lessons that
  *teach* the shell tools everything else assumes — vi/vim, pipes & redirection,
  grep, regular expressions, sed, awk, find — each with a small graded exercise.
  Foundations sort first, so `learn`/`train` walk a beginner through the tools
  before any exam task leans on them. Exam tasks that assume one of these carry
  a *soft* prerequisite pointer (a one-line "new to sed? learn it first: ..."
  nudge) — advisory only, never a gate.
- **RHCSA (EX200)** — `rhcsa/tasks/`: graded Bash tasks on a real Rocky 9 system.
- **RHCE (EX294)** — `rhce/tasks/`: Ansible playbook tasks graded by running them and
  checking end state. `games/practice list` shows all three tracks.

Each track's objectives (with a coverage checklist) live in
[rhcsa/docs/objectives.md](rhcsa/docs/objectives.md) and
[rhce/docs/objectives.md](rhce/docs/objectives.md).

## Host setup (one time)

The provisioning script needs libvirt/KVM on the host. On Fedora:

```bash
sudo dnf install -y virt-install libvirt qemu-kvm genisoimage
sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt "$USER"
```

The last command adds you to the `libvirt` group, but your session won't see it
until it re-reads your groups. Either:

- **Quickest (one terminal):** run `newgrp libvirt` **on its own**, then run the
  commands below in that same terminal. Don't paste `newgrp` together with later
  commands — it starts a new shell and swallows whatever you pasted after it.
- **Everywhere:** log out of your desktop and back in (GNOME: top-right system menu
  → power/your name → **Log Out**), or `reboot`.

Confirm the group is active, then build the VM (run these as separate commands):

```bash
id -nG | grep libvirt             # should print a line containing 'libvirt'
./setup/provision-fedora.sh       # build it (downloads Rocky 9 image, ~600 MB once)
./setup/connect.sh                # SSH in   (or: ./setup/connect.sh --console)
./setup/provision-fedora.sh --force   # tear down and rebuild from scratch
```

## Practice (inside the Rocky VM)

Once you're on the Rocky machine, clone this repo. The simplest way in is to let
the trainer decide what you should practise:

```bash
git clone https://github.com/smaarmstrong/redhat ~/redhat && cd ~/redhat

make train     # picks the next task for you — new material, or an older one due for review
#   ...do the task on the system...
make check     # grade it, then `make train` again for the next one
```

`make train` interleaves new tasks (in sequence) with spaced-repetition reviews
of things you've already passed, so you never have to decide what to work on.

If you'd rather drive it yourself, the full runner is still there:

```bash
./games/practice list                # every task, grouped by domain, with your status
./games/practice start create-user   # show a task and set up its starting state
#   ...do the task on the system...
./games/practice check create-user   # grade the end state — pass/fail per requirement
./games/practice solution create-user   # reveal a reference solution
./games/practice status              # your XP, streak, completion
```

See [games/README.md](games/README.md) for details and
[rhcsa/docs/TASK-FORMAT.md](rhcsa/docs/TASK-FORMAT.md) for how tasks are authored.

## Status

Working trainer: **70 graded tasks** across ~20 skill areas plus composite
**project** scenarios, covering 59 of the RHCSA (EX200) objectives — see the
coverage checklist in [rhcsa/docs/objectives.md](rhcsa/docs/objectives.md). Graders
run inside the practice machine and check persistent end state, exam-style.
