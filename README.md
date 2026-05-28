# octobot

Personal, reusable Claude Code skills — language-agnostic productivity
workflows that travel with you across every project.

Modeled on [mattpocock/skills](https://github.com/mattpocock/skills).

## Install

Claude Code discovers skills at `~/.claude/skills/<name>/SKILL.md` (flat,
one level deep — category subfolders are not scanned). Symlink each skill
individually:

```bash
mkdir -p ~/.claude/skills
for s in ~/code/octobot/skills/*/*/; do
  ln -s "${s%/}" "$HOME/.claude/skills/$(basename "$s")"
done
```

Open any project, start Claude Code, and the skills below appear in the
skill list.

## Skills

### productivity
- **write-a-skill** — meta-skill that scaffolds new skills consistently.
- **handoff** — produce a structured handoff doc for a fresh session.
- **grill-me** — Socratic loop to remove ambiguity before implementing.
- **caveman** — terse-mode: no preamble, no summaries, code + one-line why.

## Adding a skill

Run `/write-a-skill` in any project. It will ask for name, trigger, and
success criteria, then scaffold `skills/<category>/<name>/SKILL.md` in this
repo.
