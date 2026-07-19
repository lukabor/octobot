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
The metaharness cycle scribe-OKF → architect → blueprint → ferry →
implement → review+verify → jj-atomic. _Avoid_: pipeline, workflow (those
describe the dev-* orchestrators).

**OKF**:
Open-knowledge-format — the agent-first wiki at a target project's
`./OKF/`; layout contract in
[scribe-OKF/okf-layout.md](../skills/loop/scribe-OKF/okf-layout.md).
_Avoid_: docs folder, wiki (unqualified), knowledge base.

**Spec**:
A blueprint-produced file `OKF/specs/NNN-<slug>.md` with status
frontmatter; the unit implement executes. _Avoid_: ticket, issue, task.

**Brief**:
The written contract a mutating subagent receives before spawning —
goal, OKF/spec references, verify command. A locked spec can serve as
the brief. _Avoid_: prompt (ambiguous).

**Seal**:
The jj-atomic describe step where scratch becomes artifact; the sieve
fires here. _Avoid_: commit (mechanics), merge.

**House cap**:
110 lines per skill file (GLOSSARY.md excepted). _Avoid_: limit, budget.
