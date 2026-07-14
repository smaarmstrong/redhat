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
# forwards to ./games/practice — see `./games/practice help` for the full CLI.

PRACTICE := ./games/practice

.PHONY: learn train next check solution list status help

learn:    ; @$(PRACTICE) learn      ## teach the next task, then set it up to try
train:    ; @$(PRACTICE) train      ## pick + set up the next task (new or review)
next:     ; @$(PRACTICE) train      ## alias for `make train`
check:    ; @$(PRACTICE) check      ## grade the task you're currently on
solution: ; @$(PRACTICE) solution   ## reveal the reference solution for it
list:     ; @$(PRACTICE) list       ## every task, grouped by domain, with status
status:   ; @$(PRACTICE) status     ## your XP, streak and completion
help:     ; @$(PRACTICE) help       ## the full practice CLI
