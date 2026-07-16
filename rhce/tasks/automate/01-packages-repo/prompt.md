Work in /opt/rhce/packages-repo/. Write `playbook.yml` targeting the `managed`
group that:

1. Uses the `ansible.builtin.yum_repository` module to define a repository with
   - repo id `localdvd`
   - baseurl `file:///mnt/dvd/BaseOS`
   - gpgcheck disabled

2. Installs the `tree` package.

Run it with `ansible-playbook`. Your playbook must be idempotent (a second run
changes nothing).

Note: installing `tree` needs a working package source. The grader accepts the
package from whatever repo is available; the repo definition is graded from the
generated `/etc/yum.repos.d/localdvd.repo` file, not from a live `file:///mnt/dvd`
mirror.
