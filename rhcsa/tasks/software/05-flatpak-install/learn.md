THE IDEA

  Once a Flatpak remote (like Flathub) is configured, installing an app is a
  single command. Flatpak apps are named by a reverse-DNS "application id":
  GNOME Calculator is org.gnome.Calculator. You install by id, from a named
  remote, and Flatpak downloads the app plus any shared "runtime" it needs.

    flatpak install <remote> <app-id>

---

  This task depends on the previous two: flatpak installed, and the flathub
  remote added. Setup best-effort arranges both. Confirm the remote is
  there before we install:

```run
flatpak remotes
```

  You should see flathub listed. If it's missing, add it first (that's the
  flatpak-repo task):

    flatpak remote-add --if-not-exists flathub \
      https://flathub.org/repo/flathub.flatpakrepo

---

WHY IT MATTERS

  "Install and remove Flatpak software packages" is the stated objective.
  It's a bonus on the RHCSA, but it rounds out software management: dnf for
  the OS, flatpak for desktop apps. The mechanics — install by app id from a
  remote — are worth having in your fingers.

---

HOW TO DO IT

  Install GNOME Calculator from flathub. The -y accepts the prompts
  (including any runtime it needs to pull down).

  Installing system-wide is privileged, so we prefix it with `sudo` —
  a normal user who's been granted sudo, exactly the exam setup.
  (Listing remotes and apps with `flatpak remotes` / `flatpak list`
  is read-only and needs no sudo.)

```run
sudo flatpak install -y flathub org.gnome.Calculator
```

  Heads-up: this genuinely downloads from the network, and the first
  Flatpak app on a system also pulls a shared GNOME runtime, so it can take
  a few minutes. Watch it resolve the app plus its runtime, download, then
  report the install.

  (If more than one remote offered the same id, Flatpak would ask you to
  disambiguate — naming the remote, flathub, avoids that.)

---

CHECK IT WORKED

  List installed Flatpak apps and look for the id — this mirrors the
  grader, which checks the application column for org.gnome.Calculator:

```run
flatpak list --columns=application
```

  Seeing org.gnome.Calculator in that list means it's installed. That's the
  task done.

---

GOTCHAS

  - Needs the remote AND the network. No flathub remote, or no internet,
    and the download can't happen. Order matters: remote first, then install.
  - Install by app id (org.gnome.Calculator), not by a friendly name like
    "Calculator" — the id is exact and case-sensitive.
  - This can be slow the first time because of the shared runtime download;
    don't assume it hung.
  - To undo it later: `flatpak uninstall org.gnome.Calculator` (and
    `flatpak uninstall --unused` to reclaim orphaned runtimes).
