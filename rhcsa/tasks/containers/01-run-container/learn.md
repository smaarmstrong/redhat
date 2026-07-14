THE IDEA

  A container is a single process (plus its dependencies) running in
  isolation from the rest of the system. On RHEL/Rocky the tool that
  runs them is podman — a drop-in for the old docker command, but
  daemonless. You hand it an image (a packaged filesystem), it starts
  a process inside it, and by default it isolates that process's
  network too.

  Two things make a container actually useful as a background service:

    detached   it runs in the background instead of tying up your
               terminal (the -d flag), and

    published  a port inside the container is wired to a port on the
    port       host, so the outside world can reach it (the -p flag).

  That's this whole task: run a named, detached container with a
  published port.

---

  First, confirm podman is here and see what images the setup already
  pulled for us:

```run
podman images
```

  You should see ubi9/ubi (or alpine) already cached — setup.sh
  pre-pulled a small image so we can work offline. We'll use whichever
  is present.

---

WHY IT MATTERS

  "Run this service in a container, in the background, reachable on
  port X" is the shape of nearly every real container job — and the
  exam's bonus container task. The -d and -p flags are the two you
  cannot skip: without -d the container ties up your shell; without -p
  nothing outside the container can ever reach the service.

  Note the container's own command here is `sleep infinity`. A real
  web image would run a web server that stays up on its own; ours has
  no such server, so we give it a command that simply never exits.
  That keeps the container in the running state, which is what gets
  graded.

---

HOW TO DO IT

  One command does it all. Break it down:

    podman run        start a new container
    -d                detached (background)
    --name web        call it "web" (so we can refer to it later)
    -p 8080:80        host 8080  ->  container 80
    <image>           the filesystem to run
    sleep infinity    the command that keeps it alive

  Run it:

```run
podman run -d --name web -p 8080:80 $(podman image exists registry.access.redhat.com/ubi9/ubi && echo registry.access.redhat.com/ubi9/ubi || echo docker.io/library/alpine) sleep infinity
```

  Podman prints a long hex container ID. That means it started. In an
  exam you'd just type the image name directly, e.g.

    podman run -d --name web -p 8080:80 \
      registry.access.redhat.com/ubi9/ubi sleep infinity

  the $(...) above just auto-picks whichever image is cached.

---

  Read the -p flag carefully: it is HOST:CONTAINER. So 8080:80 means
  "listen on 8080 out here, forward it to 80 in there." Getting the
  order backwards is the classic mistake — 80:8080 would publish the
  wrong port and fail the grader.

---

CHECK IT WORKED

  List running containers:

```run
podman ps
```

  You should see "web" with a STATUS of "Up ..." and a PORTS column
  showing 0.0.0.0:8080->80/tcp. That arrow is the published port.

---

  You can ask podman directly about the port mapping:

```run
podman port web
```

  It prints "80/tcp -> 0.0.0.0:8080". That's exactly what the grader
  inspects: container "web" exists, is running, and host 8080 maps to
  container port 80.

---

GOTCHAS

  - -p is HOST:CONTAINER, in that order. 8080:80 is right here.
  - Without -d the container runs in the foreground and podman won't
    return your prompt; the graders run non-interactively, so always
    detach.
  - The container needs a long-running command. If you forget
    `sleep infinity`, ubi's default command exits immediately and the
    container drops to "Exited" — which fails "is running".
  - --name web matters: the grader looks for that exact name. A
    container with no --name gets a random one and won't be found.
  - In production you'd run this rootless (as a normal user). Here we
    run as root only so the root grader can inspect it.
