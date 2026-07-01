# RHCSA (EX200) exam objectives

The official study points, used here as the **canonical content map**. Every
objective becomes one or more atomic skills, which roll up into composite,
exam-shaped scenarios. The checkboxes double as a coverage tracker: tick one
once it has a task **with an end-state grader**.

> **The rule that shapes every grader:** as with all Red Hat performance-based
> exams, *configurations must persist after reboot without intervention.* So
> graders check persistent end state (fstab/UUID, `systemctl enable`, firewalld
> `--permanent`, etc.), never just the running state — and the reset loop should
> reboot or rebuild to enforce it.

Source: Red Hat RHCSA exam objectives.

## Understand and use essential tools
- [ ] Access a shell prompt and issue commands with correct syntax
- [x] Use input-output redirection (`>`, `>>`, `|`, `2>`, etc.)
- [x] Use `grep` and regular expressions to analyze text
- [x] Access remote systems using SSH
- [ ] Log in and switch users in multi-user targets
- [x] Archive, compress, unpack, and uncompress files using `tar`, `gzip`, and `bzip2`
- [x] Create and edit text files
- [x] Create, delete, copy, and move files and directories
- [x] Create hard and soft links
- [x] List, set, and change standard ugo/rwx permissions
- [ ] Locate, read, and use system documentation (`man`, `info`, `/usr/share/doc`)

## Manage software
- [x] Configure access to RPM repositories
- [x] Install and remove RPM software packages
- [ ] Configure access to Flatpak repositories
- [ ] Install and remove Flatpak software packages
- [x] Create simple shell scripts
- [x] Conditionally execute code (`if`, `test`, `[]`, etc.)
- [x] Use looping constructs (`for`, etc.) to process files / command-line input
- [x] Process script inputs (`$1`, `$2`, etc.)
- [ ] Process output of shell commands within a script

## Operate running systems
- [ ] Boot, reboot, and shut down a system normally
- [ ] Boot systems into different targets manually
- [ ] Interrupt the boot process to gain access to a system
- [x] Identify CPU/memory intensive processes and kill processes
- [x] Adjust process scheduling
- [x] Manage tuning profiles
- [x] Locate and interpret system log files and journals
- [x] Preserve system journals
- [x] Start, stop, and check the status of network services
- [x] Securely transfer files between systems

## Configure local storage
- [x] List, create, and delete partitions on GPT disks
- [x] Create and remove physical volumes
- [x] Assign physical volumes to volume groups
- [x] Create and delete logical volumes
- [x] Configure systems to mount file systems at boot by UUID or label
- [x] Add new partitions, logical volumes, and swap non-destructively
- [x] Extend existing logical volumes

## Create and configure file systems
- [x] Create, mount, unmount, and use VFAT, ext4, and XFS file systems
- [x] Mount and unmount network file systems using NFS
- [x] Configure autofs
- [x] Diagnose and correct file permission problems

## Deploy, configure, and maintain systems
- [x] Schedule tasks using `at`, `cron`, and systemd timer units
- [x] Start/stop services and configure services to start automatically at boot
- [x] Configure systems to boot into a specific target automatically
- [x] Configure time service clients
- [x] Install and update packages from the Red Hat CDN, a remote repo, or local files
- [x] Modify the system bootloader

## Manage basic networking
- [x] Configure IPv4 and IPv6 addresses
- [x] Configure hostname resolution
- [x] Configure network services to start automatically at boot
- [x] Restrict network access using `firewalld` and `firewall-cmd`

## Manage users and groups
- [x] Create, delete, and modify local user accounts
- [x] Change passwords and adjust password aging for local user accounts
- [x] Create, delete, and modify local groups and group memberships
- [x] Configure privileged access (sudo)

## Manage security
- [x] Configure firewall settings using `firewall-cmd`/`firewalld`
- [x] Manage default file permissions (umask)
- [x] Configure key-based authentication for SSH
- [x] Set enforcing and permissive modes for SELinux
- [x] List and identify SELinux file and process context
- [x] Restore default file contexts
- [x] Manage SELinux port labels
- [x] Use Boolean settings to modify system SELinux settings
