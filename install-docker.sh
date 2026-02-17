#!/usr/bin/env bash
set -euo pipefail

echo "=== Updating system ==="
sudo apt update
sudo apt upgrade -y

echo "=== Installing prerequisites ==="
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    apt-transport-https

echo "=== Creating Docker keyring directory ==="
sudo mkdir -p /etc/apt/keyrings

if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
    echo "=== Adding Docker GPG key ==="
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
else
    echo "=== Docker GPG key already exists, skipping ==="
fi

echo "=== Adding Docker repository ==="
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" \
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "=== Updating package index ==="
sudo apt update

echo "=== Installing Docker Engine & Compose ==="
sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

echo "=== Enabling and starting Docker ==="
sudo systemctl enable --now docker

echo "=== Adding user '$USER' to docker group ==="
sudo usermod -aG docker "$USER"

echo "=== Applying new group membership ==="
# Only works in interactive shells; safe to ignore if running via SSH
newgrp docker <<EOF
echo "=== Docker group applied ==="
EOF

echo "=== Docker installation complete ==="
echo "Log out and back in if Docker commands still require sudo."
