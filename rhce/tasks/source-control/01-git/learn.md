THE IDEA

  Playbooks are code, and code belongs in version control. Git is the
  tool: it tracks the history of a set of files in a "repository" (a
  directory with a hidden .git folder holding all the history). The
  everyday loop is three steps:

    clone    copy an existing repository to work on
    add      stage a file so the next commit will include it
    commit   record the staged changes as a permanent snapshot

  That clone / add / commit rhythm is what this task drills.

---

  Setup prepared a bare repository at /opt/rhce/git/origin.git. "Bare"
  means it holds history but has no working files checked out — it's the
  kind of repo you clone FROM (a stand-in for a remote), and it needs no
  network. Take a look:

```run
cd /opt/rhce/git && ls -la
```

---

WHY IT MATTERS

  RHCE explicitly covers managing playbooks with git — cloning a repo,
  adding files, committing. In real automation work every playbook,
  role, and inventory lives in git so changes are reviewable and
  reversible. The exam wants to see you can drive the basic workflow
  confidently, and it also depends on git identity being configured so
  commits don't error out (setup already set a global user.name and
  user.email for us).

---

HOW TO DO IT

  Step 1 — clone the bare origin into a directory named work. git
  creates work/, copies the history, and checks out the files:

```run
cd /opt/rhce/git && rm -rf work && git clone /opt/rhce/git/origin.git work
```

  Look inside — you'll see the README.md that came from origin, plus a
  .git directory:

```run
cd /opt/rhce/git/work && ls -la
```

---

  Step 2 — create a new file, then stage it with git add. Staging tells
  git "include this in my next commit":

```run
cd /opt/rhce/git/work
cat > playbook.yml <<'PB'
---
- name: Placeholder play
  hosts: all
  tasks: []
PB
git add playbook.yml
```

  Check the status — playbook.yml should show as a new file staged to be
  committed:

```run
cd /opt/rhce/git/work && git status
```

---

  Step 3 — commit the staged change with a message. This records the
  snapshot in the repo's history:

```run
cd /opt/rhce/git/work && git commit -m "Add playbook"
```

---

CHECK IT WORKED

  The grader wants work/ to be a git repo where playbook.yml is tracked
  and at least one commit exists. Confirm the file is tracked (git
  ls-files lists everything git knows about):

```run
cd /opt/rhce/git/work && git ls-files
```

  You should see playbook.yml (and README.md). Now confirm the commit
  landed by viewing the history:

```run
cd /opt/rhce/git/work && git log --oneline
```

  Two lines: the original "init" from origin and your "Add playbook".

---

GOTCHAS

  - add then commit are two separate steps. A file you created but never
    `git add`ed stays untracked and won't be in the commit — this is the
    most common trip-up.
  - A commit needs a message. `git commit -m "..."` supplies it inline;
    a bare `git commit` opens an editor, which is awkward mid-exam.
  - Commits fail with "please tell me who you are" if user.name /
    user.email aren't set. Setup configured them globally here; on a
    fresh machine you'd run `git config --global user.email ...` first.
  - Clone into the exact directory name asked for (`work`). Cloning to a
    default name or the wrong path fails the check that work/ exists.
