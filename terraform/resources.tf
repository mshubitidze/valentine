provider "cloudflare" {
  api_key = var.cloudflare_token
  email   = var.cloudflare_email
}
provider "random" {
}
provider "docker" {
  host = "tcp://${var.lxc_hostname}:2375"
}
