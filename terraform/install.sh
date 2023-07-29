#!/bin/bash

# Update package lists and install OpenJDK 11
sudo apt-get update
sudo apt install openjdk-11-jre -y

# Install Jenkins and Docker
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update && sudo apt-get install jenkins -y
sudo service jenkins restart
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins

# Install Git and Kubernetes command-line tool (kubectl)
sudo apt install git-all
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl


# Import the Microsoft GPG key
curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

# Add the Azure CLI repository
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list

# Update package lists and install the Azure CLI
sudo apt-get update
sudo apt-get install azure-cli


# Install MySQL server and client
sudo apt-get update
sudo apt-get install -y mysql-server mysql-client


# Create a new user and database
sudo mysql << EOF
CREATE USER 'fabio'@'localhost' IDENTIFIED BY 'fabio';
CREATE DATABASE teste;
GRANT ALL PRIVILEGES ON teste.* TO 'fabio'@'localhost';
FLUSH PRIVILEGES;
EOF