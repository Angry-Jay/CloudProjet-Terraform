# Read all YAML files from k8s-manifests directory
locals {
  manifests_path = "${path.module}/../../k8s-manifests"
  manifest_files = fileset(local.manifests_path, "*.yaml")
  
  # Exclude redis-deployment.yaml (Redis is offloaded to Proxmox VM) and vote-hpa.yaml
  # We keep redis-service.yaml, redis-endpoint.yaml, and redis-secret.yaml for external Redis connection
  excluded_files = ["redis-deployment.yaml", "vote-hpa.yaml", "db-data-pvc.yaml"]
  
  # Decode all YAML files into Kubernetes manifests
  manifests = {
    for file in local.manifest_files :
    file => yamldecode(file("${local.manifests_path}/${file}"))
    if !contains(local.excluded_files, file) # because redis is managed manually to show both ways
  }
}

# Create a kubernetes_manifest resource for each YAML file
resource "kubernetes_manifest" "manifest" {
  for_each = local.manifests
  
  manifest = each.value

}

output "manifest_output" {
    value = {
        files   = local.manifest_files
        decoded = local.manifests
        applied = { for k, r in kubernetes_manifest.manifest : k => r.manifest }
    }
    description = "Files found, decoded YAML, and applied manifest objects (if created)"
    
}