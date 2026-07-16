THE IDEA

  Playbooks live in git. But playbooks often need secrets — database
  passwords, API tokens, TLS keys. You cannot commit those in plaintext.
  Ansible Vault is the answer: it encrypts a variables file so it's safe to
  store anywhere, and transparently decrypts it in memory when a playbook
  runs. Your play uses the variable as normal; the value on disk is
  ciphertext.

  An encrypted file is recognisable at a glance — its first line is
  literally:

    $ANSIBLE_VAULT;1.1;AES256

  The password that locks and unlocks it can come from a file (via
  --vault-password-file) or a prompt (--ask-vault-pass). Here it's been
  handed to you in /opt/rhce/vault/vaultpass.

---

  Your working directory is /opt/rhce/vault. Look at the password file
  you'll use to encrypt and decrypt:

```run
cat /opt/rhce/vault/vaultpass
```

  That single line IS the vault password. Keep such a file mode 0600.

---

WHY IT MATTERS

  "Use Ansible Vault in playbooks to protect sensitive data" is a required
  objective, and the exam absolutely will make you both create an
  encrypted file AND consume it from a play that runs unattended. The two
  halves people trip on: getting the file into $ANSIBLE_VAULT form, and
  then remembering to SUPPLY the password when running the playbook — a
  play that reads a vaulted var but isn't given the password just errors.

---

HOW TO DO IT

  The interactive way the exam expects is `ansible-vault create secret.yml`
  — it opens an editor and encrypts what you type on save. Since a lesson
  can't drive an editor, we'll do the equivalent non-interactively: write
  the plaintext, then encrypt it in place. Same end result — a file whose
  first line is $ANSIBLE_VAULT.

  Step 1 — create the plaintext vars, then encrypt it with the password
  file:

```run
cd /opt/rhce/vault
cat > secret.yml <<'VARS'
db_password: s3cret
VARS
ansible-vault encrypt --vault-password-file vaultpass secret.yml
```

  Look — it's now ciphertext:

```run
head -1 /opt/rhce/vault/secret.yml
```

---

  Step 2 — write a playbook that loads the vaulted file with vars_files
  and uses the variable. To Ansible, db_password is just an ordinary
  variable once decrypted; here we write it out to a file to prove the
  decryption worked:

```run
cd /opt/rhce/vault
cat > playbook.yml <<'PB'
---
- name: Use a vaulted variable
  hosts: managed
  gather_facts: false
  vars_files:
    - secret.yml
  tasks:
    - name: Write the decrypted secret to a file
      ansible.builtin.copy:
        content: "{{ db_password }}"
        dest: /opt/rhce/vault/out.txt
        mode: '0600'
PB
```

  Step 3 — run it, SUPPLYING the vault password so Ansible can decrypt
  secret.yml at load time:

```run
cd /opt/rhce/vault
ansible-playbook --vault-password-file vaultpass playbook.yml
```

---

CHECK IT WORKED

  out.txt should contain the decrypted value, s3cret — that's what the
  grader looks for:

```run
cat /opt/rhce/vault/out.txt; echo
```

  And you can decrypt the vars file on demand to view it, without changing
  the file on disk, using ansible-vault view:

```run
cd /opt/rhce/vault
ansible-vault view --vault-password-file vaultpass secret.yml
```

---

GOTCHAS

  - You MUST pass the password when running. A play with vars_files
    pointing at an encrypted file fails with "Attempting to decrypt but no
    vault secrets found" unless you add --vault-password-file (or
    --ask-vault-pass).
  - --vault-password-file takes a FILE containing the password, not the
    password itself. Point it at vaultpass, not at "vaultpw123".
  - Never commit the vaultpass file. In real life it's kept out of the
    repo; only the encrypted secret.yml is safe to store.
  - To change an already-encrypted file later, use ansible-vault edit
    (opens it decrypted in an editor and re-encrypts on save) — don't try
    to edit the ciphertext by hand.
