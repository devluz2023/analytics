#!/bin/bash

# Import the public repository GPG keys
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Register the Microsoft SQL Server Ubuntu repository for SQL Server 2019
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/18.04/mssql-server-2019.list)"

# Update and install SQL Server
sudo apt-get update
sudo apt-get install -y mssql-server

# Prompt to run setup
echo "+-------------------------------------------------------------------------+"
echo "| Please run 'sudo /opt/mssql/bin/mssql-conf setup' to complete the setup of Microsoft SQL Server."
echo "+-------------------------------------------------------------------------+"

# Install curl if not installed
if ! command -v curl &> /dev/null
then
    sudo apt install curl
fi

# Import the public repository GPG keys for command-line tools
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Register the Microsoft Ubuntu repository for command-line tools
curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list

# Update and install SQL Server command-line tools
sudo apt-get update 
sudo apt-get install mssql-tools unixodbc-dev

# Add tools to PATH for login sessions
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile

# Add tools to PATH for interactive/non-login sessions
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
