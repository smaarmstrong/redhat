# ansible — Learning Ansible with Rocky, as quizzes

Knowledge quizzes over the Rocky Linux **[Learning Ansible with Rocky](https://docs.rockylinux.org/books/learning_ansible/00-toc/)**
book: read a chapter section, then `practice` quizzes you on it — multiple
choice for concepts, type-the-command for `ansible`/module usage. Passing a quiz
puts it into the same spaced-repetition review cycle as every other task, so the
book knowledge comes back for review right when you'd start to forget it.

Same format and runner as the [rocky](../rocky/README.md) Admin-Guide track;
this one just follows the Ansible book instead. Take it with `practice`:

```
./games/practice list ansible          # this track's quizzes and your status
./games/practice train ansible         # let it pick the next ansible quiz
./games/practice start 01-concepts     # a specific quiz (trailing name is enough)
```

While you take a quiz the runner prints a `guide:` link to the matching page of
the online book for that chapter. The chapter -> page map lives in
`games/practice` (`GUIDE_PAGES["ansible"]`); `./games/quizcheck` fails if a
chapter is missing from it.

## Chapters

All nine chapters of the book are covered.

| Dir | Book chapter | Online page |
|---|---|---|
| `01-basics` | Ansible Basics | `learning_ansible/01-basic/` |
| `02-intermediate` | Ansible Intermediate | `learning_ansible/02-advanced/` |
| `03-file-management` | File Management | `learning_ansible/03-working-with-files/` |
| `04-ansible-galaxy` | Ansible Galaxy | `learning_ansible/04-ansible-galaxy/` |
| `05-deployments` | Deploy With Ansistrano | `learning_ansible/05-deployments/` |
| `06-large-scale` | Large Scale infrastructure | `learning_ansible/06-large-scale-infrastructure/` |
| `07-filters` | Working With Filters | `learning_ansible/07-working-with-filters/` |
| `08-server-optimizations` | Management server optimizations | `learning_ansible/08-management-server-optimizations/` |
| `09-jinja-templates` | Working With Jinja Template in Ansible | `learning_ansible/09-working-with-jinja-template/` |

## Attribution

Question content is derived from the
[Learning Ansible with Rocky](https://docs.rockylinux.org/books/learning_ansible/00-toc/)
book, copyright The Rocky Enterprise Software Foundation and the documentation's
authors (Antoine Le Morvan et al.), published under
[Creative Commons BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
In keeping with that licence, this derived quiz content is likewise CC BY-SA 4.0.

## Task format

A quiz task is `ansible/tasks/<chapter>/<nn-name>/` containing `meta.json` (with
`"kind": "quiz"`), `prompt.md` (which section to read), and `quiz.json` — see
[rhcsa/docs/TASK-FORMAT.md](../rhcsa/docs/TASK-FORMAT.md) for the schema.
Validate quiz data with `./games/quizcheck` after any edit.
