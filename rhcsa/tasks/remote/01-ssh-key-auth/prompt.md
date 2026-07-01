The account `deploy` already exists and the SSH server is running.

Set up SSH key-based authentication so that `root` can log in to
`deploy@localhost` **without being prompted for a password**:

  • If root has no SSH key pair yet, generate one.
  • Install root's public key so that `deploy` trusts it.

When you are done, this must succeed with no password prompt:

    ssh deploy@localhost

The `deploy` user's `~/.ssh` directory and `authorized_keys` file must have
the correct, restrictive ownership and permissions (otherwise sshd will
refuse to use them). This configuration must survive a reboot.
