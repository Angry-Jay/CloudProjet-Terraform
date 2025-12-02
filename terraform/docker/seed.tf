resource "docker_container" "seed" {
  name     = "voting-app-seed"
  image    = docker_image.seed.name
  must_run = false

  depends_on = [
    docker_container.nginx
  ]

  env = [
    "TARGET_HOST=nginx",
    "TARGET_PORT=8000"
  ]

  networks_advanced {
    name = docker_network.front_tier.name
  }

  restart = "no"
}
