PROJECT: Onboard a new engineer

A new engineer, Nadia, is joining the ops team. Provision her account end to
end: identity, privileged access, password policy, key-based SSH login, and a
project directory. Everything must survive a reboot.

Requirements:

  1. Create a group named engineering with GID 5000. Create a user named
     nadia whose:
       • primary group may be her own user private group (default),
       • supplementary groups include engineering,
       • comment (GECOS) is exactly: Nadia Ops
       • login shell is /bin/bash

  2. Grant nadia FULL sudo access (run any command as any user) via a drop-in
     file under /etc/sudoers.d. The file MUST validate with `visudo -cf`.

  3. Set password-aging policy for nadia:
       • maximum days between changes: 90
       • minimum days between changes: 1
       • warning period before expiry: 14

  4. Configure SSH key-based authentication so that root can log in as
     nadia on the local host WITHOUT a password:
       • root has an SSH keypair,
       • nadia's ~/.ssh/authorized_keys contains root's public key,
       • ~/.ssh is mode 700 and authorized_keys is mode 600, both owned by
         nadia,
       • sshd is running.
     After this, `ssh nadia@localhost` from root must succeed non-interactively.

  5. Create the directory /home/nadia/reports owned by nadia:engineering with
     mode 2770 (setgid, group rwx, no access for others).
