services:
  dev:
    build:
      context: .
      dockerfile: Dockerfile
      target: development
    container_name: <project-name>-dev
    volumes:
      - .:/usr/<package_name>

  production:
    build:
      context: .
      dockerfile: Dockerfile
      target: production
    container_name: <project-name>-prod
    volumes:
      - .:/usr/<package_name>
