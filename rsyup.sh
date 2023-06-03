#!/bin/bash

# Default values
remote_host=""
remote_user=""
remote_path=""
local_path=$(pwd)
action=""

# Function to display the loading bar
show_progress() {
    local progress=$1
    local bar_length=30
    local filled_length=$((progress * bar_length / 100))
    local bar=""
    local percentage=""

    for ((i = 0; i < filled_length; i++)); do
        bar+="="
    done

    for ((i = filled_length; i < bar_length; i++)); do
        bar+=" "
    done

    percentage="[${bar}] ${progress}%"
    echo -ne "\r$percentage"
}

# Function to download files from the server
download_files() {
    echo "Downloading files from the server..."
    rsync -avz --progress -e "ssh" "${remote_user}@${remote_host}:${remote_path}/" "${local_path}/" | \
        awk 'BEGIN{ ORS="" } { show_progress($2) } END { print "" }'
    echo "Download complete!"
}

# Function to upload files to the server
upload_files() {
    echo "Uploading files to the server..."
    rsync -avz --progress -e "ssh" "${local_path}/" "${remote_user}@${remote_host}:${remote_path}/" | \
        awk 'BEGIN{ ORS="" } { show_progress($2) } END { print "" }'
    echo "Upload complete!"
}

# Function to display help information
show_help() {
    echo "Usage: ./script.sh [OPTIONS]"
    echo "Options:"
    echo "  -h, --help       Show help information"
    echo "  -v, --version    Show version information"
    echo "  -D, --download   Download files from the server"
    echo "  -U, --upload     Upload files to the server"
    echo "  -H, --host       Remote host"
    echo "  -u, --user       Remote user"
    echo "  -d, --dir        Remote directory path"
    echo "  -S, --source     Local source path (default: current directory)"
}

# Function to display version information
show_version() {
    echo "Script Version 1.0"
    echo "Author: Khant Nyar"
    echo "Email: khantsithuphyo2001@gmail.com"
    echo "GitHub: https://github.com/Khant-Nyar"
}

# Main script
while [[ $# -gt 0 ]]; do
    case "$1" in
        -D|--download)
            action="download"
            shift
            ;;
        -U|--upload)
            action="upload"
            shift
            ;;
        -H|--host)
            remote_host=$2
            shift 2
            ;;
        -u|--user)
            remote_user=$2
            shift 2
            ;;
        -d|--dir)
            remote_path=$2
            shift 2
            ;;
        -S|--source)
            local_path=$2
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            show_version
            exit 0
            ;;
        *)
            echo "Invalid option: $1"
            exit 1
            ;;
    esac
done

# Check if required options are provided
if [[ -z $remote_host || -z $remote_user || -z $remote_path ]]; then
    echo "Please provide the required options: -H, -u, -d"
    exit 1
fi

# Check the selected action
if [[ "$action" == "download" ]]; then
    download_files
elif [[ "$action" == "upload" ]]; then
    upload_files
else
    echo "Please specify '-D' or '--download' for download, or '-U' or '--upload' for upload."
    exit 1
fi
