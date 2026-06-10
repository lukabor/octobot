services:
  dev:
    build:
      context: .
      dockerfile: Dockerfile
      target: development
    container_name: <project-name>-dev
    volumes:
      - .:/usr/<package_name>

  # No source mount: production runs the baked image as built.
  production:
    build:
      context: .
      dockerfile: Dockerfile
      target: production
    container_name: <project-name>-prod
