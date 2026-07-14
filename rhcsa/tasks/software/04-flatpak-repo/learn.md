THE IDEA

  RPM and dnf handle the operating system. Flatpak is a different,
  desktop-focused packaging system: it distributes applications (think
  GIMP, GNOME Calculator) in self-contained bundles that carry their own
  libraries, so they run the same on any distro. Flatpak apps come from
  "remotes" — the Flatpak equivalent of a dnf repository. The big public
  one is Flathub.

  Before you can install any Flatpak app, the system needs a remote to pull
  it from. Adding Flathub is that setup step.

---

  Flatpak is not part of a base install, so first confirm it's present
  (setup best-effort installs it). Run:

```run
flatpak --version
```

  Then see which remotes are already configured:

```run
flatpak remotes
```

  On a fresh box this is often empty, or lists only a vendor remote. We're
  going to add one called flathub. (If flatpak is missing entirely, this is
  a bonus task that needs the flatpak package and internet — it can't be
  completed offline.)

---

WHY IT MATTERS

  The objective "configure access to Flatpak repositories" is the Flatpak
  mirror of configuring a dnf repo. It's a bonus on the RHCSA, but it's a
  clean, self-contained skill: one command wires up a remote, and it's the
  prerequisite for actually installing Flatpak apps (the next task).

---

HOW TO DO IT

  Add the Flathub remote from its .flatpakrepo descriptor file. The
  --if-not-exists flag makes the command safe to re-run — it won't error if
  the remote is already there:

```run
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

  Breaking down the arguments:

    remote-add        the sub-command that registers a new remote
    --if-not-exists   don't fail if a remote named flathub already exists
    flathub           the name we're giving this remote (what the grader
                      checks for)
    https://...       the .flatpakrepo file describing where Flathub lives
                      and its GPG key

  This talks to the network to fetch the repo descriptor, so it needs
  internet access. (You can add it system-wide as above, or per-user with
  --user; the grader looks at the default `flatpak remotes` view.)

---

CHECK IT WORKED

  List the remotes and confirm flathub is there — this is precisely what
  the grader inspects:

```run
flatpak remotes
```

  You should see a row whose name is flathub. That's the whole task.

---

GOTCHAS

  - The remote NAME is what's graded (flathub), not the URL. Add it under a
    different name and the check fails even though it works.
  - Needs network. remote-add downloads the .flatpakrepo descriptor, so an
    offline machine can't complete this.
  - Adding a remote installs nothing — it just registers where apps come
    from. Installing an actual app is the separate next task.
  - --if-not-exists makes this idempotent; without it, re-adding an existing
    remote errors out.
