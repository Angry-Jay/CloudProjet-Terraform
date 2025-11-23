resource "docker_image" "vote" {
  name = "voting-app-vote:latest"
  build {
    context    = "./voting-services/vote"
    dockerfile = "Dockerfile"
  }
}

resource "docker_image" "result" {
  name = "voting-app-result:latest"
  build {
    context    = "./voting-services/result"
    dockerfile = "Dockerfile"
  }
}

resource "docker_image" "worker" {
  name = "voting-app-worker:latest"
  build {
    context    = "./voting-services/worker"
    dockerfile = "Dockerfile"
  }
}

resource "docker_image" "redis" {
  name = "redis:alpine"
}

resource "docker_image" "db" {
  name = "postgres:15-alpine"
}

resource "docker_image" "nginx" {
  name = "voting-app-nginx:latest"
  build {
    context    = "./voting-services/nginx"
    dockerfile = "Dockerfile"
  }
}

resource "docker_image" "seed" {
  name = "voting-app-seed:latest"
  build {
    context    = "./voting-services/seed"
    dockerfile = "Dockerfile"
  }
}
