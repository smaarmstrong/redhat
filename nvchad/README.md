# nvchad — Neovim as an IDE (NvChad), as quizzes

Knowledge quizzes over the Rocky Linux **[NvChad](https://docs.rockylinux.org/books/nvchad/)**
book, which walks you through turning Neovim into a full IDE with the NvChad
configuration (aimed at writing Markdown documentation for Rocky Linux). Read a
page, then `practice` quizzes you on it — multiple choice for concepts,
type-the-command for simple invocations. Passing a quiz joins the same
spaced-repetition review cycle as every other task.

Same format and runner as the other quiz tracks
([rocky](../rocky/README.md), [ansible](../ansible/README.md),
[bash](../bash/README.md), [rsync](../rsync/README.md),
[incus](../incus/README.md), [sag](../sag/README.md),
[security](../security/README.md)). Take it with `practice`:

```
./games/practice list nvchad             # this track's quizzes and your status
./games/practice train nvchad            # let it pick the next quiz
./games/practice start 08-marksman       # a specific quiz (trailing name is enough)
```

While you take a quiz the runner prints a `guide:` link to the matching page of
the online book. The chapter -> page map lives in `games/practice`
(`GUIDE_PAGES["nvchad"]`); `./games/quizcheck` fails if a chapter with quizzes
is missing from it.

## Chapters

The book is deliberately *not* chaptered — after the install pages you can read
in any order. The directory names below follow the sidebar's reading order. The
Overview page is the book root and has no standalone page path, so it shows no
`guide:` link (its prompt carries the URL directly).

| Dir | Book page | Online page |
|---|---|---|
| `01-overview` | Overview | `nvchad/` (book root) |
| `02-additional-software` | Additional Software | `nvchad/additional_software/` |
| `03-install-neovim` | Install Neovim | `nvchad/install_nvim/` |
| `04-install-nvchad` | Install NvChad | `nvchad/install_nvchad/` |
| `05-example-config` | Example Config | `nvchad/template_chadrc/` |
| `06-nerd-fonts` | Installing Nerd Fonts | `nvchad/nerd_fonts/` |
| `07-vale` | Using vale in NvChad | `nvchad/vale_nvchad/` |
| `08-marksman` | Marksman | `nvchad/marksman/` |
| `09-ui-builtin-plugins` | NvChad UI: Built-In Plugins | `nvchad/nvchad_ui/builtin_plugins/` |
| `10-ui-plugins-manager` | NvChad UI: Plugins Manager | `nvchad/nvchad_ui/plugins_manager/` |
| `11-ui-interface` | NvChad UI: NvChad Interface | `nvchad/nvchad_ui/nvchad_ui/` |
| `12-ui-using-nvchad` | NvChad UI: Using NvChad | `nvchad/nvchad_ui/using_nvchad/` |
| `13-ui-nvimtree` | NvChad UI: NvimTree | `nvchad/nvchad_ui/nvimtree/` |
| `14-plugins-overview` | Plugins: Overview | `nvchad/plugins/` |
| `15-plugins-md-preview` | Plugins: Markdown Preview | `nvchad/plugins/md_preview/` |
| `16-plugins-projectmgr` | Plugins: Project Manager | `nvchad/plugins/projectmgr/` |

## Attribution

Question content is derived from the
[NvChad](https://docs.rockylinux.org/books/nvchad/) book, copyright The Rocky
Enterprise Software Foundation and the documentation's authors (Franco Colussi,
Steven Spencer, Ganna Zhyrnova et al.), published under
[Creative Commons BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
This derived quiz content is likewise CC BY-SA 4.0.

## Task format

A quiz task is `nvchad/tasks/<chapter>/<nn-name>/` containing `meta.json`
(with `"kind": "quiz"`), `prompt.md` (which page to read), and `quiz.json` —
see [rhcsa/docs/TASK-FORMAT.md](../rhcsa/docs/TASK-FORMAT.md) for the schema.
Validate quiz data with `./games/quizcheck` after any edit.
