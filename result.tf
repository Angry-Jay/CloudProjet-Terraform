resource "docker_container" "result" {
  name  = "voting-app-result"
  image = docker_image.result.name

  networks_advanced {
    name = docker_network.front_tier.name
  }

  networks_advanced {
    name = docker_network.back_tier.name
  }

  ports {
    external = 5050
    internal = 80
  }

  ports {
    external = 9229
    internal = 9229
  }

  depends_on = [
    docker_container.db,
  ]

  restart = "on-failure"
}