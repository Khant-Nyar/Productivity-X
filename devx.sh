#!/bin/bash

# Function to display process loading
function show_loading() {
    local process_name=$1
    local progress=0

    echo -n "Installing $process_name..."

    while [ $progress -lt 100 ]; do
        echo -ne "\r"
        printf "Installing $process_name... %d%%" $progress
        sleep 0.1
        progress=$((progress + 10))
    done

    echo
}

# Function to display software list
function show_software_list() {
    echo "Software List:"
    echo "- Chrome browser"
    echo "- PHP"
    echo "- MySQL"
    echo "- Apache"
    echo "- VS Code"
    echo "- Sublime Text"
    echo "- Postman"
    echo "- Warp CLI"
    echo "- Node.js"
    echo
}

# Function to display help information
function show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Install developer software packages."
    echo
    echo "Options:"
    echo "  -h, --help      Show help information."
    echo "  -v, --version   Show version information."
    echo "  -s, --show      Show software list."
    echo "  -y, --yes       Automatically install all software without prompts."
    echo
}

# Function to display version information
function show_version() {
    echo "Developer Tools Installer v1.0"
    echo "Created by OpenAI"
    echo
}

# Check command-line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            show_version
            exit 0
            ;;
        -s|--show)
            show_software_list
            exit 0
            ;;
        -y|--yes)
            auto_install=true
            ;;
        *)
            echo "Invalid option: $1"
            echo "Use --help to see available options."
            exit 1
            ;;
    esac
    shift
done

# Update system packages
sudo apt update

# Function to prompt for installation confirmation
function prompt_installation() {
    local software_name=$1
    local install_variable=$2
    local install_message="Do you want to install $software_name? [y/n]: "

    if [[ $auto_install == true ]]; then
        eval $install_variable=true
        return
    fi

    read -p "$install_message" install_input
    if [[ $install_input =~ ^[Yy]$ ]]; then
        eval $install_variable=true
    fi
}

# Prompt for software installation confirmation
prompt_installation "Chrome browser" install_chrome
prompt_installation "PHP" install_php
prompt_installation "MySQL" install_mysql
prompt_installation "Apache" install_apache
prompt_installation "VS Code" install_vscode
prompt_installation "Sublime Text" install_sublime
prompt_installation "Postman" install_postman
prompt_installation "Warp CLI" install_warp
prompt_installation "Node.js" install_node

# Install Chrome browser
if [[ $install_chrome == true ]]; then
    show_loading "Chrome browser"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    sudo apt --fix-broken install -y
    rm google-chrome-stable_current_amd64.deb
fi

# Install PHP
if [[ $install_php == true ]]; then
    show_loading "PHP"
    sudo apt install php -y
fi

# Install MySQL
if [[ $install_mysql == true ]]; then
    show_loading "MySQL"
    sudo apt install mysql-server -y

    # Secure MySQL installation
    show_loading "MySQL secure installation"
    sudo mysql_secure_installation

    # Configure MySQL
    show_loading "MySQL configuration"
    sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY ''; FLUSH PRIVILEGES;"
fi

# Install Apache
if [[ $install_apache == true ]]; then
    show_loading "Apache"
    sudo apt install apache2 -y
fi

# Install VS Code
if [[ $install_vscode == true ]]; then
    show_loading "VS Code"
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update
    sudo apt install code -y
fi

# Install Sublime Text
if [[ $install_sublime == true ]]; then
    show_loading "Sublime Text"
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo apt-add-repository "deb https://download.sublimetext.com/ apt/stable/"
    sudo apt update
    sudo apt install sublime-text -y
fi

# Install Postman
if [[ $install_postman == true ]]; then
    show_loading "Postman"
    sudo snap install postman
fi

# Install Warp CLI
if [[ $install_warp == true ]]; then
    show_loading "Warp CLI"
    curl https://cli.fly.io/install.sh | sudo bash
fi

# Install Node.js
if [[ $install_node == true ]]; then
    show_loading "Node.js"
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Display installation summary
echo "Developer software installation completed successfully."