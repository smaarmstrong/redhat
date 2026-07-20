# security — Security Enhancements, as quizzes

Knowledge quizzes over the Rocky Linux **[Security Enhancements](https://docs.rockylinux.org/books/security_enhancements/)**
book. Read a chapter, then `practice` quizzes you on it — multiple choice for
concepts, type-the-command for tool usage. Passing a quiz joins the same
spaced-repetition review cycle as every other task.

Same format and runner as the other quiz tracks
([rocky](../rocky/README.md), [ansible](../ansible/README.md),
[bash](../bash/README.md), [rsync](../rsync/README.md),
[incus](../incus/README.md), [sag](../sag/README.md)). Take it with `practice`:

```
./games/practice list security        # this track's quizzes and your status
./games/practice train security        # let it pick the next quiz
./games/practice start 18-about-pam    # a specific quiz (trailing name is enough)
```

While you take a quiz the runner prints a `guide:` link to the matching page of
the online book. The chapter -> page map lives in `games/practice`
(`GUIDE_PAGES["security"]`); `./games/quizcheck` fails if a chapter with quizzes
is missing from it.

## Chapters

This book is new and still being written, so chapters are added as they are
published. Chapter directories mirror the book's own numbering.

| Dir | Book chapter | Online page |
|---|---|---|
| `18-about-pam` | Introduction to PAM and basic usage | `security_enhancements/18-about-pam/` |

More chapters (the book reserves lower numbers) will be added as they appear.

## Attribution

Question content is derived from the
[Security Enhancements](https://docs.rockylinux.org/books/security_enhancements/)
book, copyright The Rocky Enterprise Software Foundation and the documentation's
authors (tianci li et al.), published under
[Creative Commons BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
This derived quiz content is likewise CC BY-SA 4.0.

## Task format

A quiz task is `security/tasks/<chapter>/<nn-name>/` containing `meta.json`
(with `"kind": "quiz"`), `prompt.md` (which chapter to read), and `quiz.json` —
see [rhcsa/docs/TASK-FORMAT.md](../rhcsa/docs/TASK-FORMAT.md) for the schema.
Validate quiz data with `./games/quizcheck` after any edit.
