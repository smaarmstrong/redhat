Work in /root/rhce/error-handling/. Write `playbook.yml` that runs against the
`managed` group and contains a task that WILL fail, but handles the failure with
`block:`/`rescue:` so that the play still finishes SUCCESSFULLY. In the rescue
section, create the file `/root/rhce/error-handling/recovered.txt`. Then run it
with `ansible-playbook`. The playbook run must exit 0 (the play succeeded) and the
recovered.txt file must exist.
