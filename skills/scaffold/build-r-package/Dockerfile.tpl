FROM rocker/r-ver:4.4 AS base

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    && rm -rf /var/lib/apt/lists/*

RUN install2.r --error --skipinstalled renv

WORKDIR /usr/<package-name>

ENV RENV_PATHS_LIBRARY=renv/library

# ── production ──────────────────────────────────────────────────────────
FROM base AS production

COPY renv.lock renv.lock
COPY renv/activate.R renv/activate.R

RUN R -e "renv::restore()"

COPY . .

CMD ["R", "--vanilla", "-e", \
     "pkgload::load_all(); cat('<package-name> ready\\n')"]

# ── development ────────────────────────────────────────────────────────
FROM base AS development

COPY renv.lock renv.lock
COPY renv/activate.R renv/activate.R

RUN R -e "renv::restore()"

COPY . .

CMD ["bash"]
