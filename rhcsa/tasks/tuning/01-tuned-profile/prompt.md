The `tuned` service manages system tuning profiles. This system is currently
using the `balanced` profile.

Switch the active tuned profile to **powersave** and make sure that choice
persists across reboots (tuned records the selected profile, so a normal
`tuned-adm profile` is enough).
