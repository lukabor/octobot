# Apache 2.0 License block (Saduko-style)

Emit this block as `<license-block>` in `readme-py.template.md` **only**
when `project.license` resolves to Apache 2.0. For any other licence,
emit the one-liner `<project.name> is licensed under <project.license.text>.`
instead.

Substitute every angle-bracketed token; if a token can't be resolved
(missing author, no `project.urls.Repository`), ask the user — do not
invent.

```markdown
<project.name> is licensed under the Apache License 2.0.

You are free to:
- Use <project.name> for any purpose (commercial or non-commercial)
- Modify and distribute the code
- Use it in proprietary software
- Patent protection included

### Requirements:
- Include the LICENSE and NOTICE files
- Preserve copyright notices
- State any changes you made

### Attribution
When using <project.name>, we appreciate attribution such as:

In your project:
> Powered by <project.name> by <author>

In academic papers:
```bibtex
@software{<project.name>,
  author = {<author-surname>, <author-given>},
  title = {<project.name>: <project.description>},
  year = {<year>},
  url = {<repo-url>}
}
```

Full license: See LICENSE and NOTICE files.
```

## Token resolution

| Token | Source |
|---|---|
| `<project.name>` | `pyproject.toml` → `project.name` |
| `<project.description>` | `pyproject.toml` → `project.description` |
| `<author>` | `project.authors[0].name` (full name as given) |
| `<author-surname>` | last whitespace-separated token of `<author>` |
| `<author-given>` | everything before `<author-surname>` |
| `<year>` | current year (UTC) |
| `<repo-url>` | `project.urls.Repository`, fall back to `Homepage` |

## NOTICE file

The block references a `NOTICE` file. If the repo does not already have
one, write a minimal `NOTICE` alongside the README:

```
<project.name>
Copyright <year> <author>

This product includes software developed by <author>.
```

The Apache 2.0 licence does not *require* a NOTICE file unless the
upstream `LICENSE` says it does, but the attribution block references it,
so emit one to keep the README honest.
