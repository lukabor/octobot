services:
  dev:
    build:
      context: .
      dockerfile: Dockerfile
      target: development
    container_name: <package-name>-dev
    volumes:
      - .:/usr/<package-name>
      - renv-cache:/root/.cache/R/renv

  # No source mount: production runs the baked image as built.
  production:
    build:
      context: .
      dockerfile: Dockerfile
      target: production
    container_name: <package-name>-prod

volumes:
  renv-cache:
