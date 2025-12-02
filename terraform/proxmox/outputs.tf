output "redis_vm_ip" {
  description = "IP address of the Redis VM"
  value       = var.vm_ip
}

output "redis_connection_info" {
  description = "Information to connect to Redis"
  value = {
    host     = var.vm_ip
    port     = 6379
    ssh_user = "m23kitso"
  }
}

output "redis_password" {
  description = "Redis password (sensitive)"
  value       = var.redis_password
  sensitive   = true
}
