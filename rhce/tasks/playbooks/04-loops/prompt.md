Work in /root/rhce/loops/. Write `playbook.yml` that runs against the `managed`
group and uses a single task with a loop to create three users: `app1`, `app2`
and `app3`. Then run it with `ansible-playbook`. Your playbook must be idempotent
(a second run changes nothing).
