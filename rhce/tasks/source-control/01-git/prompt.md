Work in /opt/rhce/git/. A local repository has been prepared for you at
`/opt/rhce/git/origin.git` (a bare repo — no network needed).

1. Clone it into a directory named `work`:

       git clone /opt/rhce/git/origin.git work

2. Inside `work/`, create a file `playbook.yml` (any valid content) and add it to
   the repository:

       git add playbook.yml

3. Commit it:

       git commit -m "Add playbook"

At the end, `work/` must be a Git repository whose tracked files include
`playbook.yml`, with at least one commit.
