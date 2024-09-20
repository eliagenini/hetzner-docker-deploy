# Hetzner
variable "hcloud_token" {
  sensitive = true
}

variable "hcloud_name" {
  type = string
  default = "web-1"
}

variable "hcloud_image" {
  type = string
  default = "ubuntu-22.04"
}

variable "hcloud_server_type" {
  type = string
  default = "cx22"
}

variable "hcloud_location" {
  type = string
  default = "fsn1"
}

# Proxmox
variable "pve_endpoint" {
  type = string
}

variable "pve_username" {
  type = string
}

variable "pve_api-key" {
  type = string
  sensitive = true
}

# Cloudflare
variable "cloudflare_token" {
  type = string
  sensitive = true
}
variable "cloudflare_email" {
  type = string
}
variable "cloudflare_zone_id" {
  type = string
}
variable "cloudflare_account_id" {
  type = string
}
variable "subdomain" {
  type = string
}
variable "domain" {
  type = string
}

# Gluetun x ProtonVPN
variable "vpn_service_provider" {
  type = string
}
variable "openvpn_user" {
  type = string
}
variable "openvpn_password" {
  type = string
  sensitive = true
}
variable "server_countries" {
  type = string
}
variable "server_hostnames" {
  type = string
}

# Restreamer
variable "stream_url" {
  type = string
}
