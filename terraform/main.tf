terraform {
  required_version = ">= 0.13"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.9.0"
    }
    random = {
      source = "hashicorp/random"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    nds = {
      source  = "peknur/nds"
      version = "0.3.0"
    }
  }
}
resource "random_password" "tunnel_secret" {
  length = 64
}
resource "cloudflare_tunnel" "auto_tunnel" {
  account_id = var.cloudflare_account_id
  name       = var.lxc_hostname
  secret     = base64sha256(random_password.tunnel_secret.result)
}
resource "docker_image" "cloudflared" {
  name = "cloudflare/cloudflared:latest"
}
resource "docker_container" "cloudflared" {
  image    = docker_image.cloudflared.image_id
  name     = "cloudflared"
  hostname = "cloudflared"
  restart  = "unless-stopped"
  upload {
    executable = false
    file       = "/tmp/credentials.yml"
    content    = jsonencode({ "AccountTag" = var.cloudflare_account_id, "TunnelSecret" = base64sha256(random_password.tunnel_secret.result), "TunnelID" = cloudflare_tunnel.auto_tunnel.id })
  }
  command = ["tunnel", "run", "--credentials-file", "/tmp/credentials.yml", "var.lxc_hostname"]
  networks_advanced {
    name = docker_network.private_network.id
  }
}

resource "docker_network" "private_network" {
  name   = "my_network"
  driver = "bridge"
}

resource "docker_image" "misho-valentine" {
  name = "ghvinerias/misho-valentine:dev"
}
resource "docker_container" "misho-valentine" {
  image    = docker_image.misho-valentine.image_id
  name     = "misho-valentine"
  hostname = "misho-valentine"
  restart  = "unless-stopped"
  networks_advanced {
    name = docker_network.private_network.id
  }
}
resource "cloudflare_record" "misho-valentine" {
  zone_id = var.cloudflare_zone_id
  name    = "misho-valentine"
  value   = cloudflare_tunnel.auto_tunnel.cname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_tunnel_config" "auto_tunnel" {
  tunnel_id  = cloudflare_tunnel.auto_tunnel.id
  account_id = var.cloudflare_account_id
  config {
    ingress_rule {
      hostname = cloudflare_record.misho-valentine.hostname
      service  = "http://misho-valentine:3000"
    }
    ingress_rule {
      service = "http_status:404"
    }
  }
}
