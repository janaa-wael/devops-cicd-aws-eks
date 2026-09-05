# Flask + MySQL with Docker Compose

Milestone 1 runs the existing Flask signup, login, and wish-list application
with MySQL locally through Docker Compose. No AWS, CI/CD, or Kubernetes
resources are included.

## Prerequisites

- Docker Desktop with Docker Compose v2

## Run locally

From the repository root:

```powershell
docker compose config
docker compose build
docker compose up
```

Open <http://localhost:5002> in a browser.

Useful commands:

```powershell
docker compose ps
docker compose logs -f flask-app
docker compose logs -f mysql-services
docker compose down
```

To remove the MySQL volume and force `db/BucketList.sql` to run again, use the
destructive command below only when existing local database data is no longer
needed:

```powershell
docker compose down --volumes
```

## Local architecture

The host maps `localhost:5002` to port `5002` in `flask-app`. Compose creates a
private network on which Flask reaches MySQL using the service hostname
`mysql-services`. MySQL stores its data in the named `mysql-data` volume.
