#!/bin/bash

# Disable all swap
sudo swapoff -a

# Permanently disable swap by commenting out the swap line in /etc/fstab
sudo sed -i '/swap/d' /etc/fstab

# Set timezone to Perth/Australia
sudo timedatectl set-timezone Australia/Perth

# Create the .hushlogin directory in /root
sudo mkdir -p /root/.hushlogin

# Set hostname to webtop.eguo.xyz
sudo hostnamectl set-hostname webtop.eguo.xyz

echo "Script executed successfully."
