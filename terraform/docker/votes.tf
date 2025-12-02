resource "docker_container" "vote" {
  for_each = toset(["1", "2"])
  name     = "voting-app-vote-${each.key}"
  image    = docker_image.vote.name

  healthcheck {
    test         = ["CMD-SHELL", "curl -f http://localhost:5000 || exit 1"]
    interval     = "15s"
    timeout      = "5s"
    retries      = 2
    start_period = "5s"
  }

  depends_on = [
    docker_container.redis
  ]

  networks_advanced {
    name    = docker_network.front_tier.name
    aliases = ["vote${each.key}"]
  }

  networks_advanced {
    name    = docker_network.back_tier.name
    aliases = ["vote${each.key}"]
  }
}
