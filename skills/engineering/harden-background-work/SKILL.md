---
name: harden-background-work
description: Hard-won rules for writing a service with a background thread, a change-trigger loop, or a shared resource behind a lock — the failure modes unit tests never exercise (silent thread death, swallowed signals, locks held across network calls, busy-loop triggers, answering before the data exists). Use when the user says "harden-background-work", "daemon thread", "background loop", "trigger loop", "change detector", "watcher", "shared lock", or is about to write any long-lived loop / lock / readiness surface.
---

# harden-background-work

## When to use
- About to write a **daemon thread**, a **change-trigger loop**, a
  **watcher**, or anything that runs forever in the background.
- A **lock** will guard a resource several callers touch.
- A service answers requests whose data is built **asynchronously**.
- Read this *before* writing the thread — these are the bugs a green,
  scenario-driven unit suite does not catch (see
  `/bdd` *"After green"*).

## Core principle
**A background thread that dies takes its silence with it.** The process
keeps serving, health keeps answering, and the loop's job silently never
happens again. Everything below defends against that one failure shape.

## Before you spawn the thread
- **Parse configuration first.** A malformed env var must crash the
  *container at startup*, where it is visible — not inside a daemon thread
  minutes later, after health already said ok.
- **Arm the trigger before the work it observes.** Priming a change
  detector *after* a long initial pass absorbs everything that changed
  during the pass into the baseline — never processed. Fingerprint first,
  then index; the first check after startup catches the window.

## Inside the loop
- **Nothing may raise.** Wrap every pass; log; retry. Treat "first
  iteration fails because a dependency is still booting" as the *expected*
  startup path, not an edge case.
- **A retry must not consume the signal that scheduled it.** Keep a
  `pending` flag that *only a successful pass* clears — otherwise a transient
  error eats the trigger fire and the change is never processed.

## Locks
- **Never hold a lock across a network (or LLM) round-trip.** Scope
  the lock to the shared resource itself — per statement, rows materialised
  before release — so a minutes-long call cannot block a millisecond lookup.
  State the isolation trade-off in the lock owner's docstring.
- **Put the lock where the resource is, not where the callers are.**
  `with lock:` copy-pasted into every caller is an invariant enforced by
  author discipline; the next caller forgets it and no test notices. A
  guarded wrapper around the resource makes unlocked access
  *unrepresentable*.

## Cost and surface
- **An always-firing trigger is a busy loop with extra steps.**
  "Fire every interval, let the differ decide" is harmless until the differ
  is a full content-hash pass holding the shared lock. Check the
  steady-state cost on a *quiet* system — that's the number that matters.
- **Readiness is part of the API, not just the health endpoint.**
  If the service answers before its data exists, "not found" becomes a
  confident lie. Gate the answering surface on the same status health
  reports, and keep that vocabulary in one module.

## Guardrails
- **Never** let a background pass raise to the top of the loop.
- **Never** clear the pending flag on a failed pass.
- **Never** hold a lock across I/O you don't control.
- **Never** answer a query the underlying data can't yet satisfy — gate it.

## See also
- `/bdd` — green is necessary, not
  sufficient; budget a recall-biased review after the thread is written.
- `/review-angles` — EAFP, stale
  references, readiness — the correctness angles these loops trip over.
- `/diagnose` — when a background loop is
  silently not doing its job, start here.
