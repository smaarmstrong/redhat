# rsync — Learning Rsync, as quizzes

Knowledge quizzes over the Rocky Linux **[Learning Rsync](https://docs.rockylinux.org/books/learning_rsync/01_rsync_overview/)**
book: read a chapter, then `practice` quizzes you on it — multiple choice for
concepts, type-the-command for rsync usage. Passing a quiz puts it into the same
spaced-repetition review cycle as every other task.

Same format and runner as the [rocky](../rocky/README.md), [ansible](../ansible/README.md),
and [bash](../bash/README.md) tracks. Take it with `practice`:

```
./games/practice list rsync            # this track's quizzes and your status
./games/practice train rsync           # let it pick the next rsync quiz
./games/practice start 01-overview     # a specific quiz (trailing name is enough)
```

While you take a quiz the runner prints a `guide:` link to the matching page of
the online book. The chapter -> page map lives in `games/practice`
(`GUIDE_PAGES["rsync"]`); `./games/quizcheck` fails if a chapter with quizzes is
missing from it.

## Chapters

Added chapter by chapter as the book is read.

| Dir | Book chapter | Online page |
|---|---|---|
| `01-overview` | rsync brief description | `learning_rsync/01_rsync_overview/` |
| `02-demo-ssh` | rsync demo 01 | `learning_rsync/02_rsync_demo01/` |
| `03-demo-rsync-protocol` | rsync demo 02 | `learning_rsync/03_rsync_demo02/` |
| `04-configure` | rsync configuration file | `learning_rsync/04_rsync_configure/` |
| `05-auth-free-login` | rsync password-free authentication login | `learning_rsync/05_rsync_authentication-free_login/` |
| `06-inotify` | inotify-tools installation and use | `learning_rsync/06_rsync_inotify/` |
| `07-unison` | Use unison | `learning_rsync/07_rsync_unison_use/` |

## Attribution

Question content is derived from the
[Learning Rsync](https://docs.rockylinux.org/books/learning_rsync/01_rsync_overview/)
book, copyright The Rocky Enterprise Software Foundation and the documentation's
authors, published under
[Creative Commons BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
This derived quiz content is likewise CC BY-SA 4.0.

## Task format

A quiz task is `rsync/tasks/<chapter>/<nn-name>/` containing `meta.json` (with
`"kind": "quiz"`), `prompt.md` (which chapter to read), and `quiz.json` — see
[rhcsa/docs/TASK-FORMAT.md](../rhcsa/docs/TASK-FORMAT.md) for the schema.
Validate quiz data with `./games/quizcheck` after any edit.
