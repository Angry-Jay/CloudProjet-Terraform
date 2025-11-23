resource "docker_image" "vote" {
  name = "voting-app-vote:latest"
  build {
    context    = "./voting-service/vote"
    dockerfile = "Dockerfile"
  }
}

resource "docker_image" "result" {
  name = "voting-app-result:latest"
  build {
    context    = "./voting-service/result"
    dockerfile = "Dockerfile"
  }
}

resource "docker_image" "worker" {
  name = "voting-app-worker:latest"
  build {
    context    = "./voting-service/worker"
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
    context    = "./voting-service/nginx"
    dockerfile = "Dockerfile"
  }
}

resource "docker_image" "seed" {
  name = "voting-app-seed:latest"
  build {
    context    = "./voting-service/seed"
    dockerfile = "Dockerfile"
  }
}
