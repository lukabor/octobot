---
type: Decision
purpose: Say which skills may fire without the user asking, and on what test.
answers:
  - "Which skills may fire without the user asking?"
cites:
  - OKF/ARCHITECTURE.md
  - skills/loop/steer/SKILL.md
status: live
reversible: yes — flag the exception user-invoked like its siblings
---

# 019 — orchestrators are asked for; recon may self-fire

**Orchestrators and rituals carry `disable-model-invocation: true`** —
the loop steps, the interviews, the commit rituals. Each interrupts a
person mid-ritual, so each must be asked for by name; the flag's
mechanics are in [ARCHITECTURE.md](../ARCHITECTURE.md).

**A recon skill may self-fire.** The test is not category but two
properties together: it only reads, and its trigger is a *state* the
agent can detect rather than a phase a person drives — "about to act on
knowledge nothing has verified". A user cannot invoke what they have not
noticed. `sound` is the first and only loop skill to pass.

The test binds the **run, not the skill**. `sound` writes when it is
reached by name and reports when it fired itself — one skill, two
mouths — so the bright line holds: **nothing a user did not ask for
edits a file.** A skill that writes on a self-fire fails, however useful
that write would be, and a stamp a self-fire cannot make is a stamp a
lock can trust.

The exception is bounded by that test, not by the loop. It survives only
while the trigger stays concrete — a vague one fires on every question,
which is the failure the audit behind phases 1–8 was avoiding.
