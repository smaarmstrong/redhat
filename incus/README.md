# incus — Incus Server, as quizzes

Knowledge quizzes over the Rocky Linux **[Incus Server](https://docs.rockylinux.org/books/incus_server/00-toc/)**
book (building an enterprise primary + snapshot Incus container server, plus a
workstation-lab appendix): read a chapter, then `practice` quizzes you on it —
multiple choice for concepts, type-the-command for `incus`/`zpool`/`firewall-cmd`
usage. Passing a quiz joins the same spaced-repetition review cycle as every
other task.

Same format and runner as the [rocky](../rocky/README.md), [ansible](../ansible/README.md),
[bash](../bash/README.md), and [rsync](../rsync/README.md) tracks. Take it with
`practice`:

```
./games/practice list incus            # this track's quizzes and your status
./games/practice train incus           # let it pick the next incus quiz
./games/practice start 01-install      # a specific quiz (trailing name is enough)
```

While you take a quiz the runner prints a `guide:` link to the matching page of
the online book. The chapter -> page map lives in `games/practice`
(`GUIDE_PAGES["incus"]`); `./games/quizcheck` fails if a chapter with quizzes is
missing from it.

## Chapters

The whole book is covered.

| Dir | Book chapter | Online page |
|---|---|---|
| `00-introduction` | Introduction (Creating an Incus server) | `incus_server/00-toc/` |
| `01-install` | 1 Install and Configuration | `incus_server/01-install/` |
| `02-zfs-setup` | 2 ZFS Setup | `incus_server/02-zfs_setup/` |
| `03-init-and-user` | 3 Incus initialization and user setup | `incus_server/03-incusinit/` |
| `04-firewall` | 4 Firewall Setup | `incus_server/04-firewall/` |
| `05-images` | 5 Setting Up and Managing Images | `incus_server/05-incus_images/` |
| `06-profiles` | 6 Profiles | `incus_server/06-profiles/` |
| `07-configurations` | 7 Container Configuration Options | `incus_server/07-configurations/` |
| `08-snapshots` | 8 Container Snapshots | `incus_server/08-snapshots/` |
| `09-snapshot-server` | 9 Snapshot Server | `incus_server/09-snapshot_server/` |
| `10-automating-snapshots` | 10 Automating Snapshots | `incus_server/10-automating/` |
| `appendix-a-workstation` | Appendix A - Workstation Setup | `incus_server/30-appendix_a/` |

## Attribution

Question content is derived from the
[Incus Server](https://docs.rockylinux.org/books/incus_server/00-toc/) book,
copyright The Rocky Enterprise Software Foundation and the documentation's
authors (Steven Spencer et al.), published under
[Creative Commons BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
This derived quiz content is likewise CC BY-SA 4.0.

## Task format

A quiz task is `incus/tasks/<chapter>/<nn-name>/` containing `meta.json` (with
`"kind": "quiz"`), `prompt.md` (which chapter to read), and `quiz.json` — see
[rhcsa/docs/TASK-FORMAT.md](../rhcsa/docs/TASK-FORMAT.md) for the schema.
Validate quiz data with `./games/quizcheck` after any edit.
