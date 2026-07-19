---
type: Architecture
---

# <project> — architecture

<!-- Every claim cites a file path. Vocabulary: module / interface / seam /
     adapter (see octobot codebase-design). A claim you can't cite to a
     file doesn't belong here. -->

## Module map

TODO(scribe) — one entry per top-level module:

- **<module>** (`path/`) — what it hides behind which interface; who
  calls it.

## Main flows

TODO(scribe) — the 1–3 flows that explain most behaviour, each as a short
ordered list of `module → module` hops with file citations.

## Seams

TODO(scribe) — where behaviour can be altered without editing in place:
DI points, adapters, config boundaries. Cite each.
