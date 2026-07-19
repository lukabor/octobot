---
name: add-docker-secrets
description: Wire build-time (BuildKit mounts) and runtime (env_file/compose) secrets without leaking into image layers.
disable-model-invocation: true
---

# add-docker-secrets

## When to use
- User says "docker secrets", "add a secret", "/add-docker-secrets".
- A containerized project needs a credential: API key at runtime, or a
  token to install private packages at build time.

## Process

1. **Classify the secret** — build time or runtime?
   - *Build time*: needed only while the image builds (private PyPI
     index, GitHub PAT for `renv`/`remotes` installs).
   - *Runtime*: needed by the running code (NCBI/Entrez key, database
     password, service token).
2. **Build-time → BuildKit secret mount.** Never `ARG`/`ENV`:
   ```dockerfile
   RUN --mount=type=secret,id=gh_pat \
       GITHUB_PAT=$(cat /run/secrets/gh_pat) R -e "renv::restore()"
   ```
   ```yaml
   # docker-compose.yml
   services:
     dev:
       build:
         secrets: [gh_pat]
   secrets:
     gh_pat:
       file: ./secrets/gh_pat.txt
   ```
   The secret exists only during that `RUN`; it never lands in a layer.
3. **Runtime → `env_file` (simple) or compose `secrets:` (file-based).**
   ```yaml
   services:
     dev:
       env_file: .env        # KEY=value lines, never committed
   ```
   Code reads `Sys.getenv("ENTREZ_KEY")` / `os.environ["ENTREZ_KEY"]` —
   no fallback default containing a real value.
4. **Hygiene check** — all three must hold before finishing:
   - `.env`, `secrets/` in `.gitignore`.
   - `.env`, `.env.*`, `secrets/` in `.dockerignore` (so `COPY . .`
     can't leak them into a layer).
   - `docker history <image>` shows no secret in any layer command.
5. **Provide a `.env.example`** with placeholder values so the required
   keys are documented without the values.

## Output / done criteria
- Secret reaches the build or the process, and `docker history` plus
  `git status` show no trace of its value.
- `.env.example` lists every required key.

## Guardrails
- **Never** pass secrets via `ARG` or `ENV` in a Dockerfile — both
  persist in image metadata and layer history.
- **Never** `COPY` a file containing a secret into any stage.
- **Never** commit `.env` or `secrets/`; check `.gitignore` before
  writing them.
- **Never** echo a secret value into logs, justfile recipes, or compose
  `environment:` literals.

## See also
- [`../containerize-project/SKILL.md`](../containerize-project/SKILL.md)
  — the three-stage setup this hardens; its `.dockerignore` templates
  already exclude `.env` and `.env.*`.
