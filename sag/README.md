# sag — Sed, Awk & Grep (the Three Swordsmen), as quizzes

Knowledge quizzes over the Rocky Linux **[Sed, Awk & Grep](https://docs.rockylinux.org/books/sed_awk_grep/)**
book — the "Three Swordsmen" of text processing on GNU/Linux (`grep`, `sed`,
`awk`), plus the regular-expressions-and-wildcards groundwork they share. Read a
chapter, then `practice` quizzes you on it — multiple choice for concepts,
type-the-command for tool usage. Passing a quiz joins the same spaced-repetition
review cycle as every other task.

("sag" = **s**ed / **a**wk / **g**rep.) Same format and runner as the
[rocky](../rocky/README.md), [ansible](../ansible/README.md),
[bash](../bash/README.md), [rsync](../rsync/README.md), and
[incus](../incus/README.md) tracks. Take it with `practice`:

```
./games/practice list sag              # this track's quizzes and your status
./games/practice train sag             # let it pick the next quiz
./games/practice start 02-grep         # a specific quiz (trailing name is enough)
```

While you take a quiz the runner prints a `guide:` link to the matching page of
the online book. The chapter -> page map lives in `games/practice`
(`GUIDE_PAGES["sag"]`); `./games/quizcheck` fails if a chapter with quizzes is
missing from it.

## Chapters

The whole book is covered.

| Dir | Book chapter | Online page |
|---|---|---|
| `01-regex-wildcards` | Regular expressions and wildcards | `sed_awk_grep/1_regular_expressions_vs_wildcards/` |
| `02-grep` | Grep command | `sed_awk_grep/2_grep_command/` |
| `03-sed` | Sed command | `sed_awk_grep/3_sed_command/` |
| `04-awk` | Awk command | `sed_awk_grep/4_awk_command/` |

The book's short "Three Swordsmen" overview (everything-is-a-file, and why
grep/sed/awk go together) is folded into the first regex quiz rather than given
its own chapter.

## Attribution

Question content is derived from the
[Sed, Awk & Grep](https://docs.rockylinux.org/books/sed_awk_grep/) book,
copyright The Rocky Enterprise Software Foundation and the documentation's
authors (tianci li et al.), published under
[Creative Commons BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
This derived quiz content is likewise CC BY-SA 4.0.

## Task format

A quiz task is `sag/tasks/<chapter>/<nn-name>/` containing `meta.json` (with
`"kind": "quiz"`), `prompt.md` (which chapter to read), and `quiz.json` — see
[rhcsa/docs/TASK-FORMAT.md](../rhcsa/docs/TASK-FORMAT.md) for the schema.
Validate quiz data with `./games/quizcheck` after any edit.
