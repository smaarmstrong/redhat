# RHCE task format (Ansible)

Same 5-file layout as RHCSA (`meta.json`, `prompt.md`, `setup.sh`, `grade.sh`,
`solution.sh`), discovered by the shared `games/practice` runner under the `rhce`
track. The difference: the learner writes **Ansible artifacts** (inventory,
`ansible.cfg`, playbooks, roles, templates, vault) and the grader **runs them and
checks the end state**.

## Environment conventions

- **Control node = the practice VM.** `setup.sh` best-effort installs `ansible-core`
  (`command -v ansible-playbook || dnf -y install ansible-core`) and degrades
  gracefully in the grader if it's missing.
- **Working directory:** `setup.sh` creates a per-task project dir at
  `/root/rhce/<task-name>/` containing a starter `ansible.cfg` and `inventory`, and
  the prompt tells the learner to work there. `grade.sh` runs Ansible from that dir.
- **Managed node = localhost.** The starter inventory defines a `managed` group
  containing the control node itself:
  - module/config tasks use `localhost ansible_connection=local`;
  - SSH-key / privilege-escalation tasks target `127.0.0.1` over SSH (setup ensures
    `sshd` and a managed user), so those objectives are still gradeable on one VM.
- Real RHCE uses several separate managed nodes; the single-VM localhost convention
  keeps every task runnable while exercising the same skills.

## meta.json

```json
{
  "title": "Install a package with a playbook",
  "domain": "Automate RHCSA tasks",
  "objective": "Software packages and repositories",
  "est_min": 8,
  "needs": ""
}
```

`needs`: `""` normally, or `"managed-node"` if it genuinely requires a second host.

## grade.sh

Begins with the shared header (relocation-robust — finds `games/lib/common.sh` by
walking up):

```bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
```

Then, from the task's project dir:

1. **Check the artifacts exist / parse** — e.g. `ansible-inventory -i inventory --list`,
   `ansible-playbook --syntax-check playbook.yml`, a vault file starts with
   `$ANSIBLE_VAULT`, a role has the right directory structure.
2. **Run the playbook** and require success:
   `check "playbook runs" ansible-playbook playbook.yml`
3. **Check the end state** the playbook should have produced (`rpm -q`, `systemctl
   is-enabled`, file content, `getent`, `firewall-cmd --query-...`) — the same
   persistence-aware checks as RHCSA.
4. **Check idempotence** where relevant — a second run reports `changed=0`
   (parse `ansible-playbook` output for `changed=0.*failed=0`).

End with `grade_summary`. Degrade gracefully (`${C_Y}note${C_0}` + a failed check,
not an error) if `ansible-core` isn't installed.

## solution.sh

Writes a correct reference set of Ansible artifacts into the task's project dir
(here-docs are fine), then optionally runs them. The runner hides the header/shebang
when displaying it.

## Authoring rules

- Grade the **end state**, not the YAML style — any working playbook must pass.
- Prefer FQCN modules (`ansible.builtin.dnf`) but accept short names.
- Keep everything runnable on a single Rocky 9 VM with `ansible-core` from AppStream.
