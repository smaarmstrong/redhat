THE IDEA

  Ansible drives its managed nodes over plain SSH. Before it can do
  anything it has to be able to log in — and typing a password for every
  host, every play, is a non-starter. So the very first thing you set up
  on a fresh control node is key-based SSH: the control user gets a key
  pair, and each managed node trusts the public half.

  A key pair is two files:

    ~/.ssh/id_rsa       the PRIVATE key — stays on the control node, secret
    ~/.ssh/id_rsa.pub   the PUBLIC key — copied out to every managed node

  A managed node "trusts" your key when your public key is listed in that
  user's ~/.ssh/authorized_keys. Then SSH proves who you are with the
  private key and nobody is ever prompted for a password.

---

  In this task the control user is root and the managed user is `ansible`
  on 127.0.0.1 — we log the box into itself, which is enough to practise
  the whole flow. Your working directory is /opt/rhce/ssh-keys.

  First, notice there is no key yet — setup wiped it clean:

```run
ls -l /root/.ssh/id_* 2>/dev/null || echo "no key pair yet"
```

---

WHY IT MATTERS

  Everything else in RHCE assumes this already works. If key-based login
  isn't set up, no playbook runs, no ad-hoc command runs. On the exam the
  control node is usually pre-seeded, but "create and distribute SSH keys"
  is a listed objective in its own right, and knowing both the manual and
  the Ansible way to do it is the point.

---

HOW TO DO IT

  Step 1 — make a key pair for root, if one doesn't exist. The `-N ''`
  gives it an empty passphrase (so logins are truly non-interactive) and
  `-f` names the file:

```run
[ -f /root/.ssh/id_rsa ] || ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa
```

  You now have id_rsa and id_rsa.pub:

```run
ls -l /root/.ssh/id_rsa /root/.ssh/id_rsa.pub
```

---

  Step 2 — hand the public key to the ansible user. The classic,
  hand-typed way is one command, ssh-copy-id, which appends your public
  key to the remote authorized_keys and fixes the permissions for you:

    $ ssh-copy-id -i /root/.ssh/id_rsa.pub ansible@127.0.0.1

  That prompts for the ansible account's password the first (and only)
  time. It's exactly what the exam expects you to know.

  But this trainer is about Ansible, so let's do the same thing with a
  playbook — no password needed, because we run it locally as root. Write
  it with a heredoc:

```run
cd /opt/rhce/ssh-keys
cat > distribute.yml <<'PB'
---
- name: Distribute root's public key to the ansible user
  hosts: localhost
  connection: local
  become: true
  tasks:
    - name: Read root's public key
      ansible.builtin.slurp:
        src: /root/.ssh/id_rsa.pub
      register: rootkey

    - name: Authorise root's key for the ansible user
      ansible.posix.authorized_key:
        user: ansible
        state: present
        key: "{{ rootkey.content | b64decode }}"
PB
```

  The idea: slurp reads the .pub file (returning it base64-encoded, hence
  the b64decode filter), and the authorized_key module installs it for the
  ansible user — creating ~/.ssh with 0700 and authorized_keys with 0600,
  owned by ansible, all correctly. Run it:

```run
cd /opt/rhce/ssh-keys
ansible-playbook distribute.yml
```

---

CHECK IT WORKED

  The real proof is the thing the grader runs — a passwordless login.
  BatchMode=yes means "never prompt; fail instead", so if this returns
  cleanly, keys are working:

```run
ssh -o BatchMode=yes -o StrictHostKeyChecking=no ansible@127.0.0.1 true && echo "passwordless login OK"
```

  The grader also checks the file layout the module set up for you — that
  ~ansible/.ssh is 0700 and authorized_keys is 0600 and owned by ansible.
  Look at it:

```run
ls -ld /home/ansible/.ssh
ls -l /home/ansible/.ssh/authorized_keys
```

---

GOTCHAS

  - Permissions are load-bearing. sshd silently ignores authorized_keys
    if the file or its .ssh directory is group- or world-writable. Manual
    setups fail here constantly; ssh-copy-id and the authorized_key module
    both get it right for you.
  - Use an empty passphrase (`-N ''`) for automation keys. A passphrase
    would re-introduce the very prompt you're trying to remove.
  - authorized_key comes from the ansible.posix collection. If it isn't
    installed, the fallback is to append the .pub to authorized_keys by
    hand and chmod/chown it — same result, and the grader only cares about
    the outcome, not how you got there.
