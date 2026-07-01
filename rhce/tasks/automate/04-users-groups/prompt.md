Work in /root/rhce/users-groups/. Write `playbook.yml` targeting the `managed`
group that:

1. Creates the group `devs` with GID `6000` (`ansible.builtin.group`).
2. Creates the user `deploybot` (`ansible.builtin.user`) with
   - `devs` as a **supplementary** group
   - a comment (GECOS), e.g. "Deployment robot".

Run it with `ansible-playbook`. Your playbook must be idempotent (a second run
changes nothing).
