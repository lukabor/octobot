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

CMD ["R", "--vanilla", "-e", "targets::tar_make()"]

# ── development ────────────────────────────────────────────────────────
FROM base AS development

COPY renv.lock renv.lock
COPY renv/activate.R renv/activate.R

RUN R -e "renv::restore()"

COPY . .

CMD ["bash"]
