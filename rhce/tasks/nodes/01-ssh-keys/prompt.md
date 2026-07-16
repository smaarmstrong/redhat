Work in /opt/rhce/ssh-keys/. The managed user `ansible` already exists on this
host and `sshd` is running.

Generate an SSH key pair for `root` (if one does not already exist) and distribute
the public key so that `root` can log in as `ansible@127.0.0.1` without a password.

You may do this any way you like — for example:

  • `ssh-keygen` then `ssh-copy-id ansible@127.0.0.1`, or
  • an ad-hoc command / playbook using the `ansible.posix.authorized_key` (or
    `ansible.builtin.authorized_key`) module.

When you are done, this must succeed with no password prompt:

    ssh -o BatchMode=yes -o StrictHostKeyChecking=no ansible@127.0.0.1 true
