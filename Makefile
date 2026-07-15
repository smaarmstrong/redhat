# Convenience wrappers around ./games/practice, for when you just want to
# practise and not think about the command surface.
#
# New to the material?  Let it teach you first:
#
#     make learn     # explains the next task, then sets it up so you can try it
#     ...do the task on the system...
#     make check     # grade it   (then `make learn` again for the next one)
#
# Already know the ropes?  Just practise:
#
#     make train     # picks what you should do next (new material or a review)
#     make check     # grade it
#
# `make train` decides on its own whether to give you new material (in
# sequence) or bring back something older for review. Everything here just
# forwards to ./games/practice — run `make help` for the list, or
# `./games/practice help` for the full CLI (start/reset and per-task ids).

PRACTICE := ./games/practice
.DEFAULT_GOAL := help

.PHONY: help learn train next check solution list status cli

help: ; @printf 'redhat trainer — just run one of:\n\n  make learn      teach the next task, then set it up to try\n  make train      pick the next task for you (new material, or a review)\n  make check      grade the task you are currently on\n  make solution   reveal the reference solution for it\n  make list       every task, grouped by domain, with your status\n  make status     your XP, streak and completion\n\nFull CLI (start/reset a specific task by id):  $(PRACTICE) help\n'

learn:    ; @$(PRACTICE) learn
train:    ; @$(PRACTICE) train
next:     ; @$(PRACTICE) train
check:    ; @$(PRACTICE) check
solution: ; @$(PRACTICE) solution
list:     ; @$(PRACTICE) list
status:   ; @$(PRACTICE) status
cli:      ; @$(PRACTICE) help
