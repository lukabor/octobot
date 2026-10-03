---
type: Decision
purpose: Stop the next agent from "fixing" okf-check to resolve sealed: pins.
answers:
  - "Why doesn't `okf-check` verify that a `sealed:` pin resolves?"
cites:
  - skills/loop/write-okf/scripts/okf-check
  - skills/loop/write-okf/SKILL.md
status: live
reversible: yes — the resolution check is a few lines either side
---

# 017 — pin drift splits by what each tool can see

`okf-check` validates the **shape** of a moored ferry's `sealed:` pin —
three fields, hex hash, ISO date — and stops there. Resolving the change
id belongs to **refresh**, which has the repo in hand. The obvious
alternative, one tool doing both, breaks the rule that gives the
validator its teeth: an OKF tree copied out of its jj repo would fail a
check it cannot possibly satisfy, and a validator that cannot exit 0
outside its home repo trains people to ignore it.
