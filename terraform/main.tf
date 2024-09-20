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

    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 3.0"
    }
  }
}

provider "proxmox" {
  pm_api_url   = var.pve_endpoint
  pm_user      = var.pve_username
  pm_password  = var.pve_api-key
  pm_tls_insecure = true
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [cloudflare_zero_trust_tunnel_cloudflared_config.service]

  destroy_duration = "20s"
}

data "cloudinit_config" "service" {
  gzip          = false
  base64_encode = false

  # Configure cloudflared
  part {
    filename     = "cloudflare.sh"
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/scripts/cloudflare.sh", {
      ACCOUNT_ID    = var.cloudflare_account_id
      TUNNEL_ID     = cloudflare_zero_trust_tunnel_cloudflared.service.id
      TUNNEL_NAME   = cloudflare_zero_trust_tunnel_cloudflared.service.name
      TUNNEL_SECRET = cloudflare_zero_trust_tunnel_cloudflared.service.secret
    })
  }
}

output "rendered" {
  value = data.cloudinit_config.service.rendered
}

resource "proxmox_lxc" "web" {
  target_node = "pve"
  hostname = "lxc-tf-restream"
  ostemplate = "local:ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  password = "MyPassword0"
  unprivileged = true

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
  }
}