
terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://10.144.208.51:8006/api2/json"
  pm_tls_insecure = true
}

variable "vm_ip" {
  default = "10.144.208.109" # e.g. 10.144.208.122
}

variable "ssh_key_path" {
  default = "~/.ssh/id_rsa_cloud.pub" # public key, e.g. ~/.ssh/id_ed25519.pub
}

variable "network_config" {
  default = {
    gateway = "10.144.208.1"
    nameserver = "10.44.10.98"
  }
}

variable "redis_password" {
  description = "Password for Redis authentication"
  type        = string
  sensitive   = true
  default     = "change-me-in-production"
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key for connecting to the VM"
  type        = string
  default     = "~/.ssh/id_rsa_cloud"
}

resource "proxmox_vm_qemu" "redis_vm" {

  name = "vm-redis-m23kitso"
  vmid = split(".", var.vm_ip)[3]
  target_node = "dapi-na-cours-pve-02"
  clone = "template-debian"
  tags = "fila3"

  #cloud init config
  os_type = "cloud-init"
  ciuser = "m23kitso"
  # cipassword = "iole"
  sshkeys = file(var.ssh_key_path)



  cpu {
    cores = 1
    sockets = 1
    type = "host"
  }

  #memory
  memory = "1024"

  #network
  ipconfig0 = "ip=${var.vm_ip}/24,gw=${var.network_config.gateway}"
  nameserver = var.network_config.nameserver
  network {
    id = 0
    bridge = "vmbr0"
    model = "virtio"
  }

  #disk
  scsihw = "virtio-scsi-pci"
  disks {
    virtio {
      virtio0 {
        disk {
          size = "20G"
          storage = "vg_proxmox"
          iothread = true
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = "vg_proxmox"
        }
      }
    }
  }

  # SSH connection configuration for provisioners
  connection {
    type        = "ssh"
    user        = "m23kitso"
    private_key = file(var.ssh_private_key_path)
    host        = var.vm_ip
    timeout     = "5m"
  }

  # Automatically install and configure Redis on VM creation
  provisioner "remote-exec" {
    inline = [
      # Wait for cloud-init to complete
      "cloud-init status --wait",
      # Update package lists
      "sudo apt-get update -q",
      # Install Redis
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install -q -y redis",
      # Configure Redis to accept connections from all IPs
      "sudo sed -e '/^bind/s/bind.*/bind 0.0.0.0/' -i /etc/redis/redis.conf",
      # Set Redis password
      "sudo sed -e '/# requirepass/s/.*/requirepass ${var.redis_password}/' -i /etc/redis/redis.conf",
      # Restart Redis to apply configuration
      "sudo systemctl restart redis-server.service",
      # Verify Redis is running
      "sudo systemctl is-active redis-server.service"
    ]
  }

}

