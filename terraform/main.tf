terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.48"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [cloudflare_tunnel_config.service]

  destroy_duration = "20s"
}

data "cloudinit_config" "service" {
  gzip          = false
  base64_encode = false

  # cloud-init
  part {
    filename     = "cloud-init.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/templates/cloud-init.yaml", {
      STREAM_URL: var.stream_url
      VPN_SERVICE_PROVIDER : var.vpn_service_provider
      OPENVPN_USER : var.openvpn_user
      OPENVPN_PASSWORD: var.openvpn_password
      SERVER_COUNTRIES: var.server_countries
      SERVER_HOSTNAMES: var.server_hostnames
    })
  }

  # Configure cloudflared
  part {
    filename     = "cloudflare.sh"
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/scripts/cloudflare.sh", {
      ACCOUNT_ID    = var.cloudflare_account_id
      TUNNEL_ID     = cloudflare_tunnel.service.id
      TUNNEL_NAME   = cloudflare_tunnel.service.name
      TUNNEL_SECRET = cloudflare_tunnel.service.secret
    })
  }
}

output "rendered" {
  value = data.cloudinit_config.service.rendered
}

resource "hcloud_server" "web" {
  name        = var.hcloud_name
  image       = var.hcloud_image
  server_type = var.hcloud_server_type
  location    = var.hcloud_location
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  user_data = data.cloudinit_config.service.rendered
  //  user_data = file("${path.module}/cloud-init.yaml")
}
