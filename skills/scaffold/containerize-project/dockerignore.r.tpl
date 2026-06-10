# Keep the build context lean and secrets out of COPY . .
# Data enters containers via the compose source mount, never the image.
.git
.jj
.env
.env.*
.Rproj.user
.Rhistory
.RData
renv/library/
renv/staging/
_targets/
data/raw/
data/processed/
Dockerfile
docker-compose.yml
