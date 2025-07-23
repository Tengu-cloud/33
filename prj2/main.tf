terraform {
  required_providers {
    virtualbox = {
      source  = "terra-farm/virtualbox"  # Or "local/virtualbox" if using local
      version = "0.1.6"
    }
  }
}
resource "virtualbox_vm" "vm2" {
  name       = "vm2"
  cpu        = 2
  memory     = "8000 mib"    # Память в МБ
  vram       = 16            # Видео-память
  
 
  disk {
    path = "/home/naraka/Downloads/Rocky-9.4-x86_64-minimal.iso"
  } 

  network_adapter {
    type           = "nat"  
    nat_port_forwarding {
      guest_port    = 22   
      host_port     = 4444   
      protocol      = "tcp"
      rule_name     = "http_port_forwarding"
    }
  }

  
  provisioner "file" {
    source      = "Dockerfile"  
    destination = "/app"
  }
  provisioner "file" {
    source      = "http_serv.py"  
    destination = "/app"
  }
  provisioner "file" {
    source      = "setup.sh" 
    destination = "/tmp/setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "/tmp/setup.sh" 
    ]
  }
    connection {
      type     = "ssh"
      user     = "user1"
      private_key = "/home/naraka/.ssh/id_rsa"
      host     = self.network_adapter.0.ip_address
      port     = 4444
    }
  }
