"""The lints' shared walk over the repo's markdown pages.

A helper, not a fifth lint: no `main`, no argv contract. `link-check` and
`render-check` held a byte-identical `pages()` each; ruling the walk for
one and leaving its twin is the shape this repo has mechanised against
three times, so the walk lives here and both import it.

A page git ignores is not the repo's to gate. `HANDOFF.md` is written
per session and gitignored, and a walk that reads it lets scratch prose
redden a repo-wide check.
"""
import subprocess
from pathlib import Path

SKIP = ("OKF/blueprints/",)


def unignored(root):
    """Every `*.md` git does not ignore, relative to the root.

    `--cached --others --exclude-standard` is tracked plus
    untracked-but-not-ignored, which is exactly *not ignored*: a page is
    walked before it is ever added, so this is a `.md` census and not a
    staging gate.

    Returns None where git cannot answer — not a repo, no git on PATH.
    The caller falls back to the whole tree rather than shrinking to
    nothing: a lint that goes quiet is worse than one that over-reports.
    The catch is narrow for the same reason, so a git failure this does
    not name still surfaces instead of passing as a silent full walk.
    """
    try:
        listed = subprocess.run(
            ["git", "-C", str(root), "ls-files", "-z", "--cached",
             "--others", "--exclude-standard", "--", "*.md"],
            capture_output=True, text=True, check=True).stdout
    except (OSError, subprocess.CalledProcessError):
        return None
    return {Path(name) for name in listed.split("\0") if name}


def pages(root):
    """Every `*.md` under the root that git does not ignore.

    Sorted, dot-directories and blueprints out, as `(page, rel)`.
    """
    live = unignored(root)
    for page in sorted(root.rglob("*.md")):
        rel = page.relative_to(root)
        if live is not None and rel not in live:
            continue
        if any(part.startswith(".") for part in rel.parts):
            continue
        if rel.as_posix().startswith(SKIP):
            continue
        yield page, rel
