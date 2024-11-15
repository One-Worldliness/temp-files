#!/bin/bash

# Update package list and install necessary packages
sudo apt update && sudo apt upgrade -y
sudo apt install -y xfce4 xfce4-goodies tightvncserver x11vnc caddy

# Prompt for VNC password
read -sp "Enter VNC password: " VNC_PASSWORD
echo

# Configure VNC Server
# Start VNC server to create initial config
vncserver :1

# Kill the VNC server to modify the configuration
vncserver -kill :1

# Create a new startup file for VNC
echo "#!/bin/sh" > ~/.vnc/xstartup
echo "xrdb $HOME/.Xresources" >> ~/.vnc/xstartup
echo "startxfce4 &" >> ~/.vnc/xstartup

# Make the xstartup file executable
chmod +x ~/.vnc/xstartup

# Set VNC password
mkdir -p ~/.vnc
echo "$VNC_PASSWORD" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Start the VNC server again
vncserver :1

# Install and configure Caddy for HTTPS access
CADDY_CONFIG="/etc/caddy/Caddyfile"

# Create a basic Caddyfile configuration for HTTPS with hostname check
echo "webtop.eguo.xyz {
    reverse_proxy localhost:5901  # Proxy to VNC server (adjust port if needed)
}

{
    # Handle requests to other hostnames with a 404 response
    respond \"404 Not Found\" 404 {
        path /
    }
}" | sudo tee $CADDY_CONFIG > /dev/null

# Enable Caddy service and start it
sudo systemctl enable caddy
sudo systemctl start caddy

# Print completion message with instructions
echo "Setup complete!"
echo "You can connect to your VNC server using: vncviewer <your_server_ip>:1"
echo "Access your services via HTTPS at https://webtop.eguo.xyz"
