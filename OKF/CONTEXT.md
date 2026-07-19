---
type: Glossary
---

# octobot — context

Vocabulary for octobot itself. Skill-authoring terms (leading word,
context load, progressive disclosure, sprawl, no-op) live in
[conjure-a-skill/GLOSSARY.md](../skills/productivity/conjure-a-skill/GLOSSARY.md)
— not duplicated here.

## Language

**Skill**:
One folder under `skills/<category>/<name>/` with a SKILL.md router and
optional topic-named siblings. _Avoid_: command, plugin, prompt.

**The loop**:
The metaharness cycle write-OKF → architect → blueprint → ferry →
weave → review+verify → commit-atomic-jj. _Avoid_: pipeline, workflow (those
describe the develop-* orchestrators).

**OKF**:
Open-knowledge-format — the agent-first wiki at a target project's
`./OKF/`; layout contract in
[write-OKF/okf-layout.md](../skills/loop/write-OKF/okf-layout.md).
_Avoid_: docs folder, wiki (unqualified), knowledge base.

**Blueprint**:
A blueprint-skill-produced file `OKF/blueprints/NNN-<slug>.md` with
status frontmatter; the unit weave executes. Its `## Contract` section
states what the change must satisfy. _Avoid_: spec (superseded term —
renamed for skill↔artifact consistency), ticket, issue, task.

**Brief**:
The written contract a mutating subagent receives before spawning —
goal, OKF/blueprint references, verify command. A locked blueprint can serve as
the brief. _Avoid_: prompt (ambiguous).

**Seal**:
The commit-atomic-jj describe step where scratch becomes artifact; the sieve
fires here. _Avoid_: commit (mechanics), merge.

**House cap**:
110 lines per SKILL.md; topic-named siblings load on demand and carry
no hard cap. _Avoid_: limit, budget.
