# rocky — guide-knowledge quizzes

Knowledge quizzes over the **Rocky Linux Administrator's Guide**, taken as a
precursor to the hands-on RHCSA/RHCE tracks: read a section of the guide, then
`practice` quizzes you on it — multiple choice for background knowledge,
type-the-command for commands. Passing a quiz puts it into the same
spaced-repetition review cycle as every other task, so the book knowledge
comes back for review right when you'd start to forget it.

Quizzes are added section by section, pacing the guide as it's actually read.
While you take a quiz, the runner prints a `guide:` link to the matching page of
the online guide for that chapter, so you can read the source alongside the
questions. The chapter -> page map lives in `games/practice`
(`ROCKY_GUIDE_PAGES`); `./games/quizcheck` fails if a chapter is missing from it.

## Attribution

Question content is derived from the
[Rocky Linux Administrator's Guide](https://docs.rockylinux.org/books/admin_guide/00-toc/)
([PDF](https://rocky-linux.github.io/documentation/RockyLinuxAdminGuide.pdf)),
copyright The Rocky Enterprise Software Foundation and the documentation's
authors, published under
[Creative Commons BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
In keeping with that licence, this derived quiz content is likewise
CC BY-SA 4.0.

## Task format

A quiz task is `rocky/tasks/<chNN-domain>/<nn-name>/` containing `meta.json`
(with `"kind": "quiz"`), `prompt.md` (which guide section to read), and
`quiz.json` — see [rhcsa/docs/TASK-FORMAT.md](../rhcsa/docs/TASK-FORMAT.md)
for the schema. Validate quiz data with `./games/quizcheck` after any edit.
