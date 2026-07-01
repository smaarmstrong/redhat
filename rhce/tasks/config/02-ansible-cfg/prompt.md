Work in /root/rhce/ansible-cfg/. Create an `ansible.cfg` file that configures:

  • `[defaults]` section:
      - `inventory` = `inventory`
      - `remote_user` = `ansible`
  • `[privilege_escalation]` section:
      - `become` = `True`
      - `become_method` = `sudo`
      - `become_user` = `root`

A placeholder `inventory` file is already present in the directory.
You only need to create the `ansible.cfg` file.
