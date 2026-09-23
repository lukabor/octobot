---
type: Decision
purpose: Collapse two competing decision homes into one indexed register.
answers:
  - "Where do settled decisions live?"
cites:
  - OKF/decisions/index.md
  - skills/engineering/model-domain/decision-format.md
status: live
reversible: by re-splitting
---

# 012 — one why-register

**One why-register**: `OKF/decisions/NNN-<slug>.md`, indexed by the
question each settles. Absorbs this section and `adr/` (empty at
absorption — zero migration cost, and evidence three-of-three was
unusable); the warrant replaces the three-of-three rule. Reversible
by re-splitting.
