THE IDEA

  A container's own filesystem is disposable. Write a file inside a
  running container, then remove and recreate the container, and that
  file is gone — the writable layer dies with the container. That is
  by design: containers are meant to be cattle, not pets.

  So anything you need to KEEP — a database, uploads, logs — must live
  outside the container, on storage that outlives it. You attach that
  storage at a path inside the container with the -v flag. Two kinds:

    named volume   podman manages the storage for you under its own
                   directory.  -v appdata:/data
                   (create it with `podman volume create appdata`)

    bind mount     you point at an existing host directory.
                   -v /srv/datastore:/data

  Either satisfies this task. We'll use a named volume — it's the
  tidier, more portable choice and what podman itself recommends.

---

  See what volumes exist right now (probably none yet):

```run
podman volume ls
```

  Empty, or whatever a previous run left. We'll create one next.

---

WHY IT MATTERS

  "Keep the container's data even if the container is rebuilt" is the
  entire point of volumes, and it's a stock exam and real-world task.
  Miss it and every container restart silently wipes the app's state —
  the kind of bug that only shows up in production at 2am.

  As before the container runs `sleep infinity` so it stays up; the
  thing being graded is that persistent storage is mounted at /data
  inside it.

---

HOW TO DO IT

  First create the named volume:

```run
podman volume create appdata
```

  Podman prints the name back. That storage now exists independently
  of any container.

---

  Now run the container and attach the volume at /data. The -v flag is
  VOLUME:CONTAINER-PATH:

    -v appdata:/data     mount volume "appdata" at /data inside

  Run it:

```run
podman run -d --name datastore -v appdata:/data $(podman image exists registry.access.redhat.com/ubi9/ubi && echo registry.access.redhat.com/ubi9/ubi || echo docker.io/library/alpine) sleep infinity
```

  In an exam you'd just type the image name; the $(...) auto-picks the
  cached one.

---

  A word on SELinux. If you use a HOST BIND MOUNT (like
  -v /srv/datastore:/data) on an enforcing system, the container is
  denied access unless you relabel the directory. You do that by
  appending :Z to the mount:

    -v /srv/datastore:/data:Z

  The :Z tells podman to set a private container SELinux label on that
  directory so the container can read and write it. Named volumes are
  already labelled correctly, so appdata:/data needs no :Z — but
  remember :Z the moment you bind-mount a host path.

---

CHECK IT WORKED

  Ask podman what's mounted in the container:

```run
podman inspect -f '{{range .Mounts}}{{.Type}} {{.Source}} -> {{.Destination}}{{"\n"}}{{end}}' datastore
```

  You want a line whose destination is /data. That's exactly what the
  grader checks: container "datastore" exists, is running, and has a
  mount at /data.

---

  Prove it actually persists. Write a file through the container, into
  the volume:

```run
podman exec datastore sh -c 'echo hello > /data/proof.txt; cat /data/proof.txt'
```

  That file now lives in the appdata volume, not the container. Remove
  and recreate the container and it would still be there.

---

GOTCHAS

  - -v is SOURCE:DEST. For a named volume the source is the volume
    NAME (appdata); for a bind mount it's an absolute host PATH
    (/srv/datastore). A bare relative name that isn't a volume can
    behave surprisingly — be deliberate.
  - Bind-mounting a host dir on an enforcing SELinux system? Add :Z or
    the container gets permission-denied. Named volumes don't need it.
  - The mount must land on /data exactly — that's the graded
    destination.
  - Data in the container's own layer (not under /data) is NOT
    persistent; only the volume survives a rebuild.
