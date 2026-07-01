Allow the `http` service through the firewall in the default zone.

The rule must be PERSISTENT and also active now: add it to the permanent
configuration and reload so it takes effect in the running firewall. A
grader reboots the machine and checks both the permanent and runtime
configuration.
