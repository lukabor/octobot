---
type: Glossary
purpose: Fix octobot's own vocabulary — one canonical name per concept, with what to avoid.
answers:
  - "What is the canonical name for this concept in octobot?"
cites:
  - skills/productivity/conjure-a-skill/glossary.md
  - skills/loop/write-okf/okf-layout.md
status: live
---

# octobot — context

Vocabulary for octobot itself. Skill-authoring terms (leading word,
context load, progressive disclosure, sprawl, no-op) live in
[conjure-a-skill/glossary.md](../skills/productivity/conjure-a-skill/glossary.md)
— not duplicated here. Prose cites take a register prefix: `B-`
blueprint, `R-` why-register, `D-` ferry (R-022); links need none. A
cross-skill reference is a bare `` `/skill-name` ``, unchecked (R-023).

## Language

**Skill**:
One folder under `skills/<category>/<name>/` with a SKILL.md router and
optional topic-named siblings. _Avoid_: command, plugin, prompt.

**The loop**:
The metaharness cycle; shape in [ARCHITECTURE.md](ARCHITECTURE.md) flow 1.
_Avoid_: pipeline, workflow (those describe the develop-* orchestrators).

**OKF**:
Open-knowledge-format — the agent-first wiki at a target project's
`./OKF/`; layout contract in
[write-okf/okf-layout.md](../skills/loop/write-okf/okf-layout.md).
_Avoid_: docs folder, wiki (unqualified), knowledge base.

**Blueprint**:
A blueprint-skill-produced file `OKF/blueprints/B-NNN-<slug>.md` with
status frontmatter; the unit rig executes. Its `## Contract` section
states what the change must satisfy. _Avoid_: spec (superseded term —
renamed for skill↔artifact consistency), ticket, issue, task.

**Brief**:
The written contract a mutating subagent receives before spawning —
goal, OKF/blueprint references, verify command. A locked blueprint can serve as
the brief. _Avoid_: prompt (ambiguous).

**Seal**:
The commit-atomic-jj describe step where scratch becomes artifact; the sieve
fires here. _Avoid_: commit (mechanics), merge.

**Page plan**:
The locked set of admissible OKF pages, recorded as `index.md`'s
one-line-per-page list. write-okf proposes it from a repo scan; the user
edits and locks it. A page absent from the plan is inadmissible.
_Avoid_: TOC, sitemap, nav, wiki.json.

**Warrant**:
The frontmatter fields that justify a page's existence — `purpose`,
`answers[]`, `cites[]`, after the required `type`. No `answers` entry, or
one another page already answers, culls the page; an unresolved `cites`
path is drift. _Avoid_: metadata, header, justification.

**Derived zone**:
The `<!-- okf:derived begin/end -->` region of a page, regenerated on
every refresh. Everything outside it is the **judgement zone** —
append/supersede only, never scan-edited. _Avoid_: generated block,
managed section.

**Register**:
An append-only OKF directory or page that is the single home for one
kind of durable fact — `decisions/` (why we chose), `LEARNINGS.md` (what
we got wrong), `blueprints/` (what we built). ROADMAP holds only what is
still ahead. _Avoid_: log, archive, history.

**Why-register**:
The `OKF/decisions/` register — why we chose what we chose, indexed
question-shaped by `index.md`. _Avoid_: ADR log, decision log.

**Decision file**:
One why-register entry, `OKF/decisions/R-NNN-<slug>.md`. Numbers permanent
— supersede, never renumber. _Avoid_: ADR, decision record, register file.

**Ferry decision**:
An open question at `ferries/<topic>/D-<n>-<slug>.md` — settled by the
user, then graduated into a decision file. _Avoid_: ADR, ticket, blocker.

**Graduate**:
Moving a resolved ferry decision into the why-register at moor, leaving a
pointer in MAP.md. _Avoid_: promote, publish, merge.

**Sealed pin**:
The `sealed:` frontmatter on a moored ferry — jj change id, git hash,
date — naming the **parent** commit where the dissolved D-n files still
exist. Makes "recoverable from history" cashable. _Avoid_: ref, anchor.

**Sounding**:
The recon pass `sound` runs before a blueprint locks — the OKF, then the
nostos MCP server, then a file read only where nostos cannot answer: an
empty result, or a path with uncommitted changes. Its mark is `sounded:`
in the blueprint's frontmatter. _Avoid_: research, investigation, spike.

**Line cap**:
The per-file limit a page kind carries — 110 for SKILL.md and OKF pages,
250 for `ROADMAP.md`, `CONTEXT.md`, a guide, or a blueprint (B-031),
selected by declared `type:`, not path. Over it errors: a legal move
always exists. _Avoid_: limit, budget.

**House cap**:
The 110 itself — the line cap SKILL.md and most OKF pages share. The
wide-cap kinds are worked against, not read cold — see **Line cap**.
Topic-named siblings load on demand and carry no cap.
