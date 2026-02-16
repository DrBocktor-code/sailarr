#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "--- Updating system packages ---"
sudo apt update && sudo apt upgrade -y

echo "--- Installing initial prerequisites ---"
sudo apt install -y ca-certificates curl gnupg lsb-release apt-transport-https

echo "--- Setting up Docker GPG key ---"
sudo mkdir -p /etc/apt/keyrings
# Remove old key if it exists to prevent errors on re-run
sudo rm -f /etc/apt/keyrings/docker.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "--- Adding Docker repository to sources ---"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "--- Installing Docker Engine ---"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "--- Enabling and starting Docker service ---"
sudo systemctl enable --now docker

echo "--- Adding current user to the docker group ---"
sudo usermod -aG docker $USER

echo "-------------------------------------------------------"
echo "Installation complete!"
echo "IMPORTANT: To apply group changes without logging out,"
echo "run the following command manually:"
echo "  newgrp docker"
echo "-------------------------------------------------------"

# Note: newgrp starts a new shell session. 
# It is usually the final command in a script or run manually.
newgrp docker
