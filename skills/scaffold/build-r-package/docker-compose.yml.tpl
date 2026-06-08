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

  production:
    build:
      context: .
      dockerfile: Dockerfile
      target: production
    container_name: <package-name>-prod
    volumes:
      - .:/usr/<package-name>

volumes:
  renv-cache:
