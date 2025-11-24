resource "docker_container" "redis" {
  name  = "voting-app-redis"
  image = docker_image.redis.name

  healthcheck {
    test     = ["CMD", "/healthchecks/redis.sh"]
    interval = "30s"
    timeout  = "10s"
    retries  = 5
  }

  volumes {
    host_path      = abspath("./healthchecks")
    container_path = "/healthchecks"
  }

  restart = "on-failure"

  networks_advanced {
    name = docker_network.back_tier.name
    aliases = ["redis"]
  }
}
