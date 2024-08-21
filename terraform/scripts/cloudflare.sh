#!/usr/bin/env bash

# Cloudflared Login
sudo wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i ./cloudflared-linux-amd64.deb

# Setup Cloudflare Tunnel
cd ~
mkdir .cloudflared
cat <<EOF > .cloudflared/cert.json
{
    "AccountTag"   : "${ACCOUNT_ID}",
    "TunnelID"     : "${TUNNEL_ID}",
    "TunnelName"   : "${TUNNEL_NAME}",
    "TunnelSecret" : "${TUNNEL_SECRET}"
}
EOF

# Setup Tunnel Config
cat <<EOF > .cloudflared/config.yml
tunnel: ${TUNNEL_ID}
credentials-file: /root/.cloudflared/cert.json
EOF

sudo cloudflared service install
sudo systemctl start cloudflared