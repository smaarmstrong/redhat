# redhat

A terminal-native, Duolingo-style trainer for the **RHCSA** (and later **RHCE**) exams.

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

Over time this grows the things that make Duolingo sticky — a prerequisite skill
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
├── setup/     # runs on the HOST (Fedora/Mac) to build the Rocky 9 VM
├── games/     # the console learning tools — run INSIDE the Rocky VM
├── tasks/     # task definitions + graders (prompt / setup / grade / solution)
└── README.md
```

## Status

Early scaffold. Next step: `setup/provision-fedora.sh` — get a working Rocky 9 VM
you can SSH into, then clone this repo inside it and start on the first game.
