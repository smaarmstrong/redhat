The `cockpit` service is currently allowed through the firewall in the
default zone. It should no longer be reachable.

Permanently REMOVE the `cockpit` service from the default zone and apply
the change so it is blocked in both the running and the permanent config.

Requirements:

  • The change must PERSIST across a reboot (permanent config).
  • It must also take effect now (reload the running config).

A grader will check that `firewall-cmd --permanent --query-service=cockpit`
fails, and that the runtime query fails too after a reload.
