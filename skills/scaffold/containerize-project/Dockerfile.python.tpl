FROM python:3.11-slim AS base

# Pinned uv binary — bump the tag deliberately, never use :latest.
COPY --from=ghcr.io/astral-sh/uv:0.7 /uv /uvx /usr/local/bin/

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /usr/<package_name>

WORKDIR /usr/<package_name>

ENV UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    UV_PYTHON_DOWNLOADS=never \
    UV_PROJECT_ENVIRONMENT=/opt/venv

# ── production ──────────────────────────────────────────────────────────
FROM base AS production

COPY pyproject.toml uv.lock* ./
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev --no-install-project 2>/dev/null \
    || uv sync --no-dev --no-install-project

COPY . .
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev 2>/dev/null || uv sync --no-dev

RUN useradd --create-home --shell /usr/sbin/nologin app \
    && chown -R app:app /usr/<package_name>
USER app

ENV PATH="/opt/venv/bin:$PATH"
CMD ["python", "-c", "import <package_name>; print('<package_name> ready')"]

# ── development ────────────────────────────────────────────────────────
# Runs as root deliberately: the dev service bind-mounts the source tree
# and installs packages interactively; a non-root user fights both.
FROM base AS development

COPY pyproject.toml uv.lock* ./
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --group dev --no-install-project 2>/dev/null \
    || uv sync --group dev --no-install-project

COPY . .
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --group dev 2>/dev/null || uv sync --group dev

ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1
CMD ["bash"]
