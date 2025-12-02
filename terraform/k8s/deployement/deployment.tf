resource "kubernetes_deployment" "deployment" {
  metadata {
    name = var.metadata_name
    labels = {
      app = var.label_name
    }
    namespace = var.metadata_namespace
  }
    spec {
        replicas = 1
        selector {
            match_labels = {
                app = var.label_name
            }
        }
        template {
          metadata {
            labels = {
              app = var.label_name
            }
          }
          spec {
            container {
              image = var.container_image
              name  = var.container_name
              port {
                container_port = var.container_port
                name = var.container_port_name
              }
              liveness_probe {
                exec {
                  command = [
                    var.liveness_command
                  ]
                }
                period_seconds = 15
              }
            }
          }
        }
    }
        
}