Work in /opt/rhce/register/. Write `playbook.yml` that runs against the `managed`
group, becomes root, runs the command `id -un`, REGISTERS the result, and writes
the command's standard output (the registered variable's `.stdout`) into the file
`/opt/rhce/register/whoami.txt`. Then run it with `ansible-playbook`. Because the
play runs as root, the file must contain `root`.
