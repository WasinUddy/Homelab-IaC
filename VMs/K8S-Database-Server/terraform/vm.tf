resource "proxmox_virtual_environment_vm" "K8S-Database-Server" {
    name        = "K8S-Database-Server"
    description = "MicroK8S Node for handling database pods"
    node_name   = "DL380"
    vm_id       = 200

    agent {
        enabled = false
    }

    bios = "seabios"

    network_device {
        bridge = "vmbr1"
        model  = "virtio"
    }

    on_boot = true

    operating_system {
        type = "l26"
    }

    cpu {
        cores        = 2
        sockets      = 1
        architecture = "x86_64"
        type         = "host"
    }

    disk {
        size         = 64
        datastore_id = "SSD0"
        interface    = "virtio0"
        file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
        iothread     = true
        discard      = "on"
        speed {
            iops_read = 6400
            iops_write = 6400
        }
    }

    memory {
        dedicated = 2048
    }

    initialization {
        datastore_id = "local-lvm"
        interface    = "ide0"

        dns {
            servers = ["10.0.1.11", "1.1.1.1"]
        }

        ip_config {
            ipv4 {
                address = "10.0.60.11/24"
                gateway = "10.0.60.254"
            }   
        }

        user_account {
            username = "ase"
            keys = [data.local_file.ssh_pub_key.content]
        }
    }
}


# Load SSH key
data "local_file" "ssh_pub_key" {
    filename = "../ase.pub"
}