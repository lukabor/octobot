---
type: Decision
purpose: Make `ls ferries/` answer what deliberation is still in flight.
answers:
  - "What shape does a ferry take once it is moored?"
cites:
  - skills/loop/moor/SKILL.md
  - OKF/CONTEXT.md
status: live
reversible: OKF is not the archive of record, history is
---

# 015 — moor collapses the ferry directory into one page

Moor **collapses** `ferries/<topic>/` into `ferries/<topic>.md` —
problem shape, rejected alternatives, decision pointers. Directory
means open, file means moored, so `ls` answers what's in flight.
Deliberation stays recoverable via `sealed:` (jj change id + git
hash + date) pinned to the **parent** (`@-` at moor) — the sealing
commit cannot name itself, and the parent is where the D-n files
still exist. Unresolvable pin = drift. Reversible: OKF is not the
archive of record, history is.
