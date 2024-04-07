resource "proxmox_virtual_environment_vm" "montainer-servers" {
    name        = "montainer-servers"
    description = "Montainer Servers hosting all the montainer services"
    node_name   = "DL380"
    vm_id       = 100

    agent {
        enabled = false
    }

    bios = "seabios"

    network_device {
        bridge = "vmbr2"
        model  = "virtio"
    }

    on_boot = true

    operating_system {
        type = "l26"
    }

    cpu {
        cores        = 4
        sockets      = 1
        architecture = "x86_64"
        type         = "host"
    }

    disk {
        size         = 64
        datastore_id = "SSD1"
        interface    = "virtio0"
        file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
        iothread     = true
        discard      = "on"
    }

    memory {
        dedicated = 8192
    }

    initialization {
        datastore_id = "local-lvm"
        interface    = "ide0"

        dns {
            servers = ["10.0.1.11", "1.1.1.1"]
        }

        ip_config {
            ipv4 {
                address = "10.0.50.10/24"
                gateway = "10.0.50.254"
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