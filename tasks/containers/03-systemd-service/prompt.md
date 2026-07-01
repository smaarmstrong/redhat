Make a container start automatically at boot, managed by systemd.

Requirements:

  • Container name:   svc  (run `sleep infinity` so it stays up)
  • A systemd unit manages it and is ENABLED to start at boot.

Two accepted approaches:

  1. podman generate systemd
       podman run -d --name svc <image> sleep infinity
       podman generate systemd --name svc --files --new
       cp container-svc.service /etc/systemd/system/
       systemctl daemon-reload
       systemctl enable container-svc.service

  2. Quadlet (.container unit) — RHEL 9 native
       write /etc/containers/systemd/svc.container with an [Install]
       section (WantedBy=...), then `systemctl daemon-reload`.
       Quadlet generates a `svc.service`; enabling happens via the
       [Install] section, so `systemctl is-enabled svc.service` reports it.

The grader accepts EITHER an enabled `container-svc.service` OR a
`svc.service` produced/enabled from a Quadlet `svc.container` file.

NOTE: This is a bonus RHEL8-era container task, not part of the core RHEL9
EX200 objectives. It requires `podman` and (to pull an image) registry access.
setup.sh best-effort installs container-tools and pre-pulls a tiny image; if
unavailable the grader will note it and the task cannot be completed offline.

NOTE: Rootless containers use a user unit under ~/.config/systemd/user with
`loginctl enable-linger`. Here it is run and graded as root (system unit) so
the grader can inspect it.
