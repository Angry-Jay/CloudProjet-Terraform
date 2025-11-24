resource "docker_container" "db" {
  name  = "voting-app-db"
  image = docker_image.db.name

  healthcheck {
    test     = ["CMD", "/healthchecks/postgres.sh"]
    interval = "30s"
    timeout  = "10s"
    retries  = 5
  }

  env = [
    "POSTGRES_PASSWORD=postgres"
  ]

  volumes {
    volume_name    = docker_volume.db_data.name
    container_path = "/var/lib/postgresql/data"
  }

  volumes {
    host_path      = abspath("./healthchecks")
    container_path = "/healthchecks"
  }

  restart = "on-failure"
}
