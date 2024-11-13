#!/bin/bash

# Variables
FRP_VERSION="0.61.0"
FRP_TAR="frp_${FRP_VERSION}_linux_amd64.tar.gz"
FRP_URL="https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/${FRP_TAR}"
INSTALL_DIR="/usr/local/bin"
CONFIG_DIR="/etc"
FRPC_CONFIG="${CONFIG_DIR}/frpc.ini"
SERVICE_FILE="/etc/systemd/system/frpc.service"

# Update package index
echo "Updating package index..."
sudo apt update

# Install necessary dependencies
echo "Installing dependencies..."
sudo apt install -y wget tar

# Download frp binary
echo "Downloading frp version ${FRP_VERSION}..."
wget -O ${FRP_TAR} ${FRP_URL}

# Extract the downloaded tar file
echo "Extracting frp..."
tar -zxvf ${FRP_TAR}

# Move the frpc binary to the installation directory
echo "Moving frpc to ${INSTALL_DIR}..."
sudo mv frp_0.61.0_linux_amd64/frpc ${INSTALL_DIR}/

# Create a configuration file for frpc
echo "Creating frpc configuration file..."
sudo tee ${FRPC_CONFIG} > /dev/null <<EOL
[common]
server_addr = your_vps_ip
server_port = 7000
token = your_secure_token

[https]
type = tcp
local_ip = 127.0.0.1
local_port = 443
remote_port = 8443
EOL

# Create a systemd service file for frpc
echo "Creating systemd service file..."
sudo tee ${SERVICE_FILE} > /dev/null <<EOL
[Unit]
Description=Frp Client Service
After=network.target

[Service]
Type=simple
User=nobody
Restart=on-failure
RestartSec=5s
ExecStart=${INSTALL_DIR}/frpc -c ${FRPC_CONFIG}

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd to recognize the new service and enable it
echo "Enabling and starting frpc service..."
sudo systemctl daemon-reload
sudo systemctl enable frpc
sudo systemctl start frpc

# Check the status of the service
echo "Checking the status of the frpc service..."
sudo systemctl status frpc

# Clean up by removing the downloaded tar file and extracted directory
echo "Cleaning up..."
rm -rf ${FRP_TAR} frp_0.61.0_linux_amd64

echo "Frpc setup is complete!"