# module "kubernetes_deployment" {
#   source = "./deployement"
#   metadata_name = "redis-deplt"
#   metadata_namespace = "j23zebia"
#   label_name = "redis"
#   container_image = "redis:alpine"
#   container_name = "redis-container"
#   container_port = 6379
#   container_port_name = "redis-port"
#   liveness_command = "/healthchecks/redis.sh"
# }

# resource "kubernetes_service" "redis_service" {
#   metadata {
#     name      = "redis"
#     namespace = "j23zebia"
#     labels = {
#       app = "redis"
#     }
#   }
#   spec {
#     selector = {
#       app = "redis"
#     }
#     port {
#       port        = 6379
#       target_port = 6379
#       protocol    = "TCP"
#       name        = "redis-svc-port"
#     }
#     type = "NodePort"
#   }
# }