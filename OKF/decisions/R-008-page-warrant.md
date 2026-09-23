---
type: Decision
purpose: Give every page a machine-checkable justification for existing.
answers:
  - "What justifies a page's existence in the OKF?"
cites:
  - OKF/CONTEXT.md
  - skills/loop/write-OKF/scripts/okf-check
status: live
reversible: OKF v0.1 permits producer-defined fields after type
---

# 008 — every page carries a warrant

Every page carries a **warrant** after `type`: `purpose`, `answers[]`,
`cites[]`. Zero `answers`, or answers another page owns → inadmissible;
unresolved `cites` → drift. Doubles as routing index
(`grep -r "answers:" OKF/`). Reversible — OKF v0.1 permits
producer-defined fields after `type`.
