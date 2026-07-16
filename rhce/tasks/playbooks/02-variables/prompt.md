Work in /opt/rhce/variables/. Write `playbook.yml` that runs against the
`managed` group and defines two variables:

  • `target_file: /opt/rhce/vars/hello.txt`
  • `message: "hello from ansible"`

The playbook must create the file named by `target_file` with its content set to
the value of `message`. Use the variables (not hard-coded literals) in the task,
then run it with `ansible-playbook`. Your playbook must be idempotent (a second
run changes nothing).
