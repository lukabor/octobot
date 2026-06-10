FROM rocker/verse:4.4 AS base

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

RUN install2.r --error --skipinstalled renv

WORKDIR /usr/<project-name>

ENV RENV_PATHS_LIBRARY=renv/library

# ── production ──────────────────────────────────────────────────────────
FROM base AS production

COPY renv.lock renv.lock
COPY renv/activate.R renv/activate.R

RUN R -e "renv::restore()"

COPY . .

# tar_make() writes _targets/, so the workdir must be writable by app.
RUN useradd --create-home --shell /usr/sbin/nologin app \
    && chown -R app:app /usr/<project-name>
USER app

CMD ["R", "--vanilla", "-e", "targets::tar_make()"]

# ── development ────────────────────────────────────────────────────────
# Runs as root deliberately: the dev service bind-mounts the source tree
# and installs packages interactively; a non-root user fights both.
FROM base AS development

COPY renv.lock renv.lock
COPY renv/activate.R renv/activate.R

RUN R -e "renv::restore()"

COPY . .

CMD ["bash"]
