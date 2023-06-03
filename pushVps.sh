#!/bin/bash

# Script Author: Khant Si Thu Phyo
# Email: khantsithuphyo2001@gmail.com
# GitHub: https://github.com/Khant-Nyar
# Version: 1x0-beta

# Default values
local_code_dir=$(pwd)
git_repo=""
production_server="user@production-server.com"
production_dir="/path/to/production/directory"

# Function to display help information
display_help() {
    echo "Usage: ./script.sh [OPTION]"
    echo "Options:"
    echo "  -h, --help         Display this help and exit"
    echo "  -v, --version      Display version information and exit"
    echo "  -d, --dir=<path>   Set the local code directory path (default: current path)"
    echo "  -g, --geturl=<url> Set the Git repository remote URL"
}

# Function to display version information
display_version() {
    echo "Script Version: 1x0-beta"
    echo "Author: Khant Si Thu Phyo"
    echo "Email: khantsithuphyo2001@gmail.com"
    echo "GitHub: https://github.com/Khant-Nyar"
}

# Parse command line options
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            display_help
            exit 0
            ;;
        -v|--version)
            display_version
            exit 0
            ;;
        -d|--dir=*)
            local_code_dir="${1#*=}"
            shift
            ;;
        -g|--geturl=*)
            git_repo="${1#*=}"
            shift
            ;;
        *)
            echo "Invalid option: $1"
            display_help
            exit 1
            ;;
    esac
    shift
done

# Check if the Git repository remote URL is provided
if [ -z "$git_repo" ]; then
    echo "Git repository remote URL is required."
    display_help
    exit 1
fi

# Rest of the script ...

# Change directory to the local code repository
cd "$local_code_dir" || exit

# Add all files to Git and commit changes
git add .
git commit -m "Update local code"

# Push the changes to the 'production' branch of the Git repository
git push "$git_repo" HEAD:production

# Connect to the production server via SSH and update the code
ssh "$production_server" << EOF
    cd "$production_dir"
    git fetch --all
    git reset --hard origin/production
EOF
