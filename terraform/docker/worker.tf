resource "docker_container" "worker" {
  name  = "voting-app-worker"
  image = docker_image.worker.name

  networks_advanced {
    name = docker_network.back_tier.name
  }

  depends_on = [
    docker_container.db,
    docker_container.redis
  ]

  restart = "on-failure"
}
