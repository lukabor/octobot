services:
  dev:
    build:
      context: .
      dockerfile: Dockerfile
      target: development
    container_name: <project-name>-dev
    volumes:
      - .:/usr/<project-name>
      - renv-cache:/root/.cache/R/renv

  production:
    build:
      context: .
      dockerfile: Dockerfile
      target: production
    container_name: <project-name>-prod
    volumes:
      - .:/usr/<project-name>

volumes:
  renv-cache:
