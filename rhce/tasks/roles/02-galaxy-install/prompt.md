Work in /root/rhce/galaxy-install/.

BONUS TASK — requires internet access to Ansible Galaxy.

Create a `requirements.yml` that lists the Galaxy role `geerlingguy.ntp`, then
install it into the project's `roles/` directory with:

    ansible-galaxy role install -r requirements.yml -p roles

After installation, `roles/geerlingguy.ntp/` should exist. (If you have no network
access to Galaxy, this task cannot be completed and the grader will note it.)
