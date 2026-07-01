# RHCE (EX294) exam objectives — "RHCSA in Ansible"

The official study points, used here as the coverage map. Tick one once it has a
task **with an end-state grader**. As with all Red Hat performance-based exams,
**configurations must persist after reboot without intervention** — and Ansible
tasks should be **idempotent** (a second run reports no change).

> RHCE builds on RHCSA: you're expected to perform all RHCSA tasks, and then
> automate them with Ansible.

## Understand core components of Ansible
- [ ] Inventories
- [ ] Modules
- [ ] Variables
- [ ] Facts
- [ ] Loops
- [ ] Conditional tasks
- [ ] Plays
- [ ] Handling task failure
- [ ] Playbooks
- [ ] Configuration files
- [ ] Roles
- [ ] Use provided documentation to look up information about modules and commands

## Configure Ansible
- [ ] Create and modify `ansible.cfg`
- [ ] Modify `ansible-navigator.yml`
- [ ] Create a static host inventory file
- [ ] Create and use static inventories to define groups of hosts

## Configure Ansible managed nodes
- [ ] Create and distribute SSH keys to managed nodes
- [ ] Configure privilege escalation on managed nodes
- [ ] Deploy files to managed nodes
- [ ] Validate a working configuration using ad hoc Ansible commands

## Run playbooks
- [ ] Run playbooks with `ansible-navigator` and `ansible-playbook`
- [ ] Use `ansible-navigator` to find modules in Content Collections and use them
- [ ] Use `ansible-navigator` to create inventories and configure the environment

## Source control (Git)
- [ ] Clone a Git repository
- [ ] Add files to a Git repository

## Create Ansible plays and playbooks
- [ ] Work with commonly used Ansible modules
- [ ] Use variables to retrieve the results of running a command (register)
- [ ] Use conditionals to control play execution
- [ ] Configure error handling
- [ ] Create playbooks to configure systems to a specified state

## Use roles and Ansible Content Collections
- [ ] Create and work with roles
- [ ] Install roles from Ansible Galaxy and use them in playbooks
- [ ] Install Content Collections and use them in playbooks

## Automate standard RHCSA tasks using Ansible modules
- [ ] Software packages and repositories
- [ ] Services
- [ ] Firewall rules
- [ ] File systems
- [ ] Storage devices
- [ ] File content
- [ ] Archiving
- [ ] Task scheduling
- [ ] Security
- [ ] Users and groups

## Manage content
- [ ] Create and use templates to create customized configuration files
- [ ] Use Ansible Vault in playbooks to protect sensitive data

Source: Red Hat RHCE (EX294) exam objectives.
