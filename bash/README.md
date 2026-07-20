# bash — Learning bash with Rocky, as quizzes

Knowledge quizzes over the Rocky Linux **[Learning bash with Rocky](https://docs.rockylinux.org/books/learning_bash/00-toc/)**
book: read a chapter section, then `practice` quizzes you on it — multiple
choice for concepts, type-the-command for shell syntax. Passing a quiz puts it
into the same spaced-repetition review cycle as every other task.

Same format and runner as the [rocky](../rocky/README.md) and
[ansible](../ansible/README.md) tracks. Take it with `practice`:

```
./games/practice list bash             # this track's quizzes and your status
./games/practice train bash            # let it pick the next bash quiz
./games/practice start 01-first-script # a specific quiz (trailing name is enough)
```

While you take a quiz the runner prints a `guide:` link to the matching page of
the online book. The chapter -> page map lives in `games/practice`
(`GUIDE_PAGES["bash"]`); `./games/quizcheck` fails if a chapter with quizzes is
missing from it.

## Chapters

The whole book is covered.

| Dir | Book chapter | Online page |
|---|---|---|
| `00-generalities` | Learning bash with Rocky (Generalities) | `learning_bash/00-toc/` |
| `01-first-script` | Bash - First script | `learning_bash/01-first-script/` |
| `02-using-variables` | Bash - Using Variables | `learning_bash/02-using-variables/` |
| `03-data-manipulation` | Bash - Data entry and manipulations | `learning_bash/03-data-entry-and-manipulations/` |
| `04-check-knowledge-1` | Bash - Check your knowledge (chapters 1-3) | `learning_bash/04-check-your-knowledge/` |
| `05-tests` | Bash - Tests | `learning_bash/05-tests/` |
| `06-conditionals` | Bash - Conditional structures (if and case) | `learning_bash/06-conditional-structures/` |
| `07-loops` | Bash - Loops | `learning_bash/07-loops/` |
| `08-check-knowledge-2` | Bash - Check your knowledge (chapters 5-7) | `learning_bash/08-check-your-knowledge/` |
| `appendix-variables-logs` | Appendix - Practical Examples (Variables with logs) | `learning_bash/appendix/02-variables-logs/` |

The book's own two "Check your knowledge" pages are quizzes in their own right,
so those chapters mine the book's questions directly. Further appendix
practical-examples pages can be added under their own `appendix-*` dirs.

## Attribution

Question content is derived from the
[Learning bash with Rocky](https://docs.rockylinux.org/books/learning_bash/00-toc/)
book, copyright The Rocky Enterprise Software Foundation and the documentation's
authors, published under
[Creative Commons BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
This derived quiz content is likewise CC BY-SA 4.0.

## Task format

A quiz task is `bash/tasks/<chapter>/<nn-name>/` containing `meta.json` (with
`"kind": "quiz"`), `prompt.md` (which section to read), and `quiz.json` — see
[rhcsa/docs/TASK-FORMAT.md](../rhcsa/docs/TASK-FORMAT.md) for the schema.
Validate quiz data with `./games/quizcheck` after any edit.
