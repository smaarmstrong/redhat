THE IDEA

  A container you start by hand disappears the moment the machine
  reboots — nothing brings it back. To make a container a real service
  that comes up at boot, you hand it to systemd, the same init system
  that manages sshd, chronyd and everything else.

  There are two accepted ways on RHEL/Rocky 9:

    1. podman generate systemd   podman writes a .service unit that
                                 wraps your container. You copy it to
                                 the systemd directory and enable it.
                                 This is the RHEL 8 / early-9 way.

    2. Quadlet (.container file)  RHEL 9 native. You describe the
                                 container in a small .container file;
                                 systemd turns it into a service unit
                                 automatically. Cleaner and forward-
                                 looking.

  Both end with systemd knowing about the container and it being
  ENABLED so it starts at boot. The grader accepts either. We'll walk
  the generate-systemd route (what solution.sh does), then show the
  Quadlet alternative so you know both.

---

WHY IT MATTERS

  "Enabled to start at boot" is the exam's golden rule applied to
  containers — a container that only runs because you typed
  `podman run` fails the moment the box reboots. Letting systemd own
  the container also gives you restart-on-crash, logging via journald,
  and start/stop through the same systemctl you already use.

---

HOW TO DO IT — approach 1: generate systemd

  First run the container once, so podman has something to describe.
  Its command is `sleep infinity` so it stays up:

```run
podman run -d --name svc $(podman image exists registry.access.redhat.com/ubi9/ubi && echo registry.access.redhat.com/ubi9/ubi || echo docker.io/library/alpine) sleep infinity
```

---

  Now generate a unit FILE for it. We cd into the systemd system
  directory first so the file lands where systemd looks:

    --name svc   describe the container called svc
    --files      write a .service file (not just print it)
    --new        make the unit re-create the container on start,
                 instead of depending on this one existing forever
                 (the robust, recommended form)

```run
cd /etc/systemd/system && podman generate systemd --name svc --files --new
```

  It prints the path it wrote, e.g.
  /etc/systemd/system/container-svc.service. Note the name pattern:
  container-<containername>.service.

---

  Tell systemd to re-scan its unit files, then enable the new unit so
  it starts at boot:

```run
systemctl daemon-reload
```

```run
systemctl enable container-svc.service
```

  enable creates the symlink that wires the unit into boot. (You could
  add --now to also start it immediately, but the container is already
  running from our `podman run`, and the grader only needs it enabled.)

---

HOW TO DO IT — approach 2: Quadlet (for reference)

  You do NOT need to run this — approach 1 already solved the task.
  This is just so you recognise the RHEL 9 native way. You'd write a
  file /etc/containers/systemd/svc.container containing:

    [Container]
    Image=registry.access.redhat.com/ubi9/ubi
    ContainerName=svc
    Exec=sleep infinity

    [Install]
    WantedBy=multi-user.target default.target

  Then `systemctl daemon-reload`. Quadlet turns that .container file
  into a service named svc.service, and the [Install] section is what
  makes it enabled — there is no separate `systemctl enable` step and
  in fact you cannot enable a Quadlet-generated unit directly. The
  WantedBy line IS the enable.

---

  Note the two units are named DIFFERENTLY:

    generate systemd  ->  container-svc.service
    Quadlet           ->  svc.service

  The grader accepts either an enabled container-svc.service or a
  svc.service produced from a Quadlet svc.container. Don't mix
  approaches expecting one name and getting the other.

---

CHECK IT WORKED

  Confirm the unit exists and is enabled:

```run
systemctl is-enabled container-svc.service
```

  It should print "enabled" (or "generated"/"static" for a Quadlet
  unit — all count). That's exactly what the grader tests: a systemd
  unit manages svc, and it's enabled to start at boot.

---

  You can also see it as a real service:

```run
systemctl status container-svc.service --no-pager
```

  Active/running, with the podman command listed. This is now a
  first-class service that will return after a reboot.

---

GOTCHAS

  - Enabled, not just running. A container started with plain
    `podman run` is active now but vanishes on reboot — the grader
    checks is-enabled, so the unit MUST be enabled.
  - Unit names differ by method: container-svc.service (generate) vs
    svc.service (Quadlet). Verify the one you actually created.
  - After copying or generating any unit file, run
    `systemctl daemon-reload` or systemd won't see it. Quadlet units
    especially only appear after a daemon-reload.
  - Prefer `--new` with generate systemd: without it the unit is tied
    to this exact container object, which is more fragile.
  - Rootless in production: you'd put the unit under
    ~/.config/systemd/user, enable it with `systemctl --user enable`,
    and run `loginctl enable-linger <user>` so it starts before that
    user logs in. Here we use a system unit as root so the root grader
    can see it.
