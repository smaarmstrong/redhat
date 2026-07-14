THE IDEA

  Every process has a "nice value" — a scheduling hint from -20 to +19 that
  tells the kernel how to share CPU time. The name is the trick to remember
  it: a HIGHER nice number means the process is NICER to everything else, so
  it gets LESS CPU when there's contention. Lower (down to -20) means greedy
  and high-priority; the default for a normal job is 0.

    -20  ......  0  ......  +19
    greedy    default    nicest (lowest priority)

  Two tools cover this:

    nice     starts a NEW command with a chosen nice value
    renice   changes the nice value of a process ALREADY running

  A job is already running from the setup — /usr/local/bin/nicejob.sh at the
  default niceness of 0. We want to make it politer: nice value 10.

---

WHY IT MATTERS

  "This batch job is hogging the box during business hours — deprioritise it
  without killing it" is a real request, and adjusting scheduling is a listed
  objective. Because the process is already running, this is a renice job, not
  a nice job — knowing which tool applies is half the point.

---

STEP 1 — find the PID

  renice works on a PID, so grab it. Again `-f` matches the whole command
  line (the process is `bash /usr/local/bin/nicejob.sh`):

```run
pgrep -af nicejob
```

  Note its current nice value while we're here — the NI column should read 0:

```run
ps -o pid,ni,cmd -C bash | grep nicejob
```

---

STEP 2 — renice it

  Now raise the nice value to 10. `-n 10` sets the value, `-p` says "this is a
  PID". We feed it the PID from pgrep directly:

```run
sudo renice -n 10 -p "$(pgrep -f nicejob | head -1)"
```

  renice echoes the old and new priority so you can see it took effect. We
  use sudo because raising an already-running process's nice value (and
  touching one you don't own) needs root; note that even the owner cannot
  LOWER a nice value back down without root — that's a one-way street for
  ordinary users.

---

CHECK IT WORKED

  Read the nice value straight back off the process. `ps -o ni=` prints just
  the number, no header:

```run
ps -o ni= -p "$(pgrep -f nicejob | head -1)"
```

  That should print 10. The grader checks exactly this: the nicejob process
  is still running AND its nice value is 10.

---

GOTCHAS

  - renice for a running process; nice only for launching a new one. Don't
    reach for `nice` here — the job's already alive.
  - Don't kill and relaunch it. The task wants the SAME process reniced while
    it keeps running.
  - Nice is backwards from intuition: 10 is LOWER priority than 0, which is
    what "not urgent" wants. Bigger number = nicer = less CPU.
  - Raising niceness is easy; lowering it (e.g. back to 0, or negative) needs
    root. Use sudo and you avoid the "permission denied" surprise entirely.
  - `renice 10 -p PID` also works (the -n is optional on RHEL), but -n is the
    clear, portable form.
