Work in /opt/rhce/collection-use/.

BONUS TASK — requires internet access to Ansible Galaxy.

1. Create `collections/requirements.yml` that lists the `community.general`
   collection.
2. Install it into the project with:

       ansible-galaxy collection install -r collections/requirements.yml -p collections

3. Write a playbook `playbook.yml` (targeting the `managed` group) that uses a
   module from `community.general` — for example write a value into an INI file
   with `community.general.ini_file`, creating `/etc/myapp.ini` with section
   `[main]` key `enabled=true`.

Run it with `ansible-playbook`. (If you have no network access to Galaxy, this
task cannot be completed and the grader will note it.)
