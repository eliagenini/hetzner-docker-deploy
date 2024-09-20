provider "cloudflare" {
  api_token = var.cloudflare_token
}

resource "cloudflare_record" "service" {
  zone_id = var.cloudflare_zone_id
  name    = var.subdomain
  content   = cloudflare_zero_trust_tunnel_cloudflared.service.cname
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "random_id" "tunnel_secret" {
  byte_length = 32
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "service" {
  account_id = var.cloudflare_account_id
  name       = "service"
  secret     = random_id.tunnel_secret.b64_std
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "service" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.service.id

  config {
    ingress_rule {
      hostname = "${var.subdomain}.${var.domain}"
      service  = "http://localhost:80"
    }

    ingress_rule {
      service = "http_status:404"
    }
  }
}