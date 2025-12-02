resource "docker_network" "back_tier" {
  name = "voting-app-back-tier"
}

resource "docker_network" "front_tier" {
  name = "voting-app-front-tier"
}