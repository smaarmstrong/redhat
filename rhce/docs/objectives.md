# RHCE (EX294) exam objectives — "RHCSA in Ansible"

The official study points, used here as the coverage map. Tick one once it has a
task **with an end-state grader**. As with all Red Hat performance-based exams,
**configurations must persist after reboot without intervention** — and Ansible
tasks should be **idempotent** (a second run reports no change).

> RHCE builds on RHCSA: you're expected to perform all RHCSA tasks, and then
> automate them with Ansible.

## Understand core components of Ansible
- [x] Inventories
- [x] Modules
- [x] Variables
- [x] Facts
- [x] Loops
- [x] Conditional tasks
- [x] Plays
- [x] Handling task failure
- [x] Playbooks
- [x] Configuration files
- [x] Roles
- [x] Use provided documentation to look up information about modules and commands

## Configure Ansible
- [x] Create and modify `ansible.cfg`
- [x] Modify `ansible-navigator.yml`
- [x] Create a static host inventory file
- [x] Create and use static inventories to define groups of hosts

## Configure Ansible managed nodes
- [x] Create and distribute SSH keys to managed nodes
- [x] Configure privilege escalation on managed nodes
- [x] Deploy files to managed nodes
- [x] Validate a working configuration using ad hoc Ansible commands

## Run playbooks
- [ ] Run playbooks with `ansible-navigator` and `ansible-playbook`
- [ ] Use `ansible-navigator` to find modules in Content Collections and use them
- [ ] Use `ansible-navigator` to create inventories and configure the environment

## Source control (Git)
- [x] Clone a Git repository
- [x] Add files to a Git repository

## Create Ansible plays and playbooks
- [x] Work with commonly used Ansible modules
- [x] Use variables to retrieve the results of running a command (register)
- [x] Use conditionals to control play execution
- [x] Configure error handling
- [x] Create playbooks to configure systems to a specified state

## Use roles and Ansible Content Collections
- [x] Create and work with roles
- [x] Install roles from Ansible Galaxy and use them in playbooks
- [x] Install Content Collections and use them in playbooks

## Automate standard RHCSA tasks using Ansible modules
- [x] Software packages and repositories
- [x] Services
- [x] Firewall rules
- [x] File systems
- [ ] Storage devices
- [x] File content
- [x] Archiving
- [x] Task scheduling
- [x] Security
- [x] Users and groups

## Manage content
- [x] Create and use templates to create customized configuration files
- [x] Use Ansible Vault in playbooks to protect sensitive data

Source: Red Hat RHCE (EX294) exam objectives.
