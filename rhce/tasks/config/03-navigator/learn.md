THE IDEA

  ansible-navigator is the modern front-end for running playbooks. It
  normally runs your automation inside an "execution environment" (a
  container) and, by default, takes over your terminal with a colourful
  interactive text UI. Its behaviour is driven by a config file called
  ansible-navigator.yml.

  Unlike ansible.cfg, this one is YAML, not INI. Everything sits under a
  single top-level key, ansible-navigator, and settings nest beneath it
  by indentation.

---

  Here's our working directory — empty, so we're creating the file from
  scratch:

```run
cd /root/rhce/navigator && ls -la
```

---

WHY IT MATTERS

  The two settings this task wants are the ones people actually change:

    mode: stdout
      Turn OFF the full-screen interactive UI and just print output to
      the terminal, like the classic ansible-playbook. Much easier to
      read (and to screenshot) — and on the exam you almost always want
      plain stdout.

    playbook-artifact.enable: false
      By default navigator saves a JSON "artifact" of every run. Set
      this to false to stop it cluttering your directory.

  Being able to write a small, correctly-indented YAML config on demand
  is the graded skill here — YAML indentation trips people up under exam
  pressure.

---

HOW TO DO IT

  The prompt gives the settings as dotted paths:

    ansible-navigator.mode                     = stdout
    ansible-navigator.playbook-artifact.enable = false

  Each dot is one level of nesting in YAML. So mode sits one level in,
  and playbook-artifact/enable sits two levels in. Write it with a
  heredoc, using two spaces per level and a space after every colon:

```run
cd /root/rhce/navigator
cat > ansible-navigator.yml <<'YML'
---
ansible-navigator:
  mode: stdout
  playbook-artifact:
    enable: false
YML
```

  The leading `---` is the YAML document marker (optional but tidy).
  Note enable is indented UNDER playbook-artifact, which is itself under
  ansible-navigator.

---

CHECK IT WORKED

  First, prove it's valid YAML — a single indentation slip breaks the
  whole file. Parse it and print the structure back:

```run
cd /root/rhce/navigator && python3 -c 'import yaml,pprint;pprint.pprint(yaml.safe_load(open("ansible-navigator.yml")))'
```

  You want to see a nested dict: mode = 'stdout' and playbook-artifact =
  {'enable': False}. That's exactly what the grader walks — it resolves
  each dotted path and compares the value. (PyYAML ships with
  ansible-core, so it's already here.)

---

GOTCHAS

  - Indentation is meaning in YAML. Use spaces, never tabs, and keep it
    consistent (two spaces per level is the norm). A tab anywhere makes
    the parser reject the file.
  - Always put a space after the colon: `mode: stdout`, not
    `mode:stdout`.
  - enable's value is the YAML boolean false, not the string "false" —
    don't quote it. (The grader is lenient here, but learn the habit.)
  - The keys really do contain hyphens (playbook-artifact,
    ansible-navigator). That's fine in YAML; just type them literally.
  - Filename must be ansible-navigator.yml (some setups also accept
    .yaml). Match what the task asks for.
