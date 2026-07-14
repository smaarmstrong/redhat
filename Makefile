# Convenience wrappers around ./games/practice, for when you just want to
# practise and not think about the command surface.
#
# The whole loop is three words:
#
#     make train     # it picks what you should do next, and sets it up
#     ...do the task on the system...
#     make check     # grade it   (then `make train` again for the next one)
#
# `make train` decides on its own whether to give you new material (in
# sequence) or bring back something older for review. Everything here just
# forwards to ./games/practice — see `./games/practice help` for the full CLI.

PRACTICE := ./games/practice

.PHONY: train next check solution list status help

train:    ; @$(PRACTICE) train      ## pick + set up the next task (new or review)
next:     ; @$(PRACTICE) train      ## alias for `make train`
check:    ; @$(PRACTICE) check      ## grade the task you're currently on
solution: ; @$(PRACTICE) solution   ## reveal the reference solution for it
list:     ; @$(PRACTICE) list       ## every task, grouped by domain, with status
status:   ; @$(PRACTICE) status     ## your XP, streak and completion
help:     ; @$(PRACTICE) help       ## the full practice CLI
