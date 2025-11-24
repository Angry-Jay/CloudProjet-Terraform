resource "docker_container" "nginx" {
  name  = "voting-app-nginx"
  image = docker_image.nginx.name

  ports {
    internal = 8000
    external = 8000
  }

  networks_advanced {
    name    = docker_network.front_tier.name
    aliases = ["nginx"]
  }

  depends_on = [
    docker_container.vote
  ]

  restart = "on-failure"

}
