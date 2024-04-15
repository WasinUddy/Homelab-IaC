terraform {
  required_providers {
    proxmox = {
        source = "bpg/proxmox"
        version = "0.51.1"
    }
  }
}

provider "proxmox" {
    endpoint = "https://10.0.40.3:8006/"

    username = "root@pam"
    password = "Uddy31wa?1905"
    insecure = true

}  
