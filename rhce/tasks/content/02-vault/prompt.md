Work in /root/rhce/vault/. A vault password has already been written for you to
`/root/rhce/vault/vaultpass`.

1. Create an Ansible Vault-encrypted variables file `secret.yml` (encrypt it with
   the password in `vaultpass`) that defines:

       db_password: s3cret

   e.g.  `ansible-vault create --vault-password-file vaultpass secret.yml`
   The encrypted file must begin with the line `$ANSIBLE_VAULT`.

2. Write a playbook `playbook.yml` (targeting the `managed` group) that loads
   `secret.yml` with `vars_files` and writes the decrypted password to
   `/root/rhce/vault/out.txt` (the file's contents must be exactly the value of
   `db_password`).

3. Run it so the decryption succeeds:

       ansible-playbook --vault-password-file vaultpass playbook.yml
