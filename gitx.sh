#!/bin/bash

# Git productivity script with command-line arguments

# Function to initialize a new Git repository
initialize_git_repo() {
    git init
    echo "Initialized new Git repository."

    git add .
    git commit -m "Initial commit"
    echo "Initial commit created."

    if [[ -z $1 ]]; then
        echo "Please provide a remote repository URL."
    else
        git remote add origin $1
        git push -u origin main
        echo "Changes pushed to remote repository."
    fi
}

# Function to configure Git user name and email
configure_git_user() {
    read -p "Enter user name: " username
    read -p "Enter email: " email

    default_branch="main" # Default branch is set to "main"

    git config --global user.name "$username"
    git config --global user.email "$email"
    git config --global init.defaultBranch "$default_branch"

    echo "Git user configured:"
    echo "User Name: $username"
    echo "Email: $email"
    echo "Default Branch: $default_branch"

    read -p "Do you want to generate an SSH key? (y/n): " generate_key

    if [[ $generate_key == "y" || $generate_key == "Y" ]]; then
        ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/git_sshed
        echo "SSH key generated."
    else
        echo "Skipping SSH key generation."
    fi

    echo "Git Configuration:"
    echo "------------------"
    echo "User Name: $(git config --global user.name)"
    echo "Email: $(git config --global user.email)"
    echo "Default Branch: $(git config --global init.defaultBranch)"
    echo

    echo "SSH Key:"
    echo "--------"
    cat ~/.ssh/git_sshed.pub || echo "No SSH key found."
    echo "copy it into your github accout sshkey "
}



# Function to generate SSH key if needed
generate_ssh_key() {
    read -p "Do you want to generate an SSH key? (y/n): " generate_key

    if [[ $generate_key =~ ^[Yy]$ ]]; then
        read -p "Enter your email: " email
        ssh-keygen -t ed25519 -C "$email"
        echo "SSH key generated."
    else
        echo "Skipping SSH key generation."
    fi
}

# Function to add and commit changes with a message
add_and_commit() {
    if [[ -z $1 ]]; then
        echo "Please provide a commit message."
    else
        git add .
        git commit -m "$1"
        echo "Changes committed with message: $1"
    fi
}

# Function to push changes to a remote repository
push_changes() {
    git push origin HEAD
    echo "Changes pushed to remote repository."
}

# Function to pull changes from a remote repository
pull_changes() {
    git pull origin HEAD
    echo "Changes pulled from remote repository."
}

# Function to view the Git status
view_status() {
    git status
}

# Function to view the Git log
view_log() {
    git log
}

# Function to switch to a different branch
switch_branch() {
    if [[ -z $1 ]]; then
        echo "Please provide a branch name."
    else
        git checkout $1
        echo "Switched to branch: $1"
    fi
}

# Function to print the menu options
print_menu() {
    echo "Git Productivity Script"
    echo "-----------------------"
    echo "1. Initialize a new Git repository"
    echo "2. Configure Git user"
    echo "3. Generate SSH key"
    echo "4. Add and commit changes"
    echo "5. Push changes to remote repository"
    echo "6. Pull changes from remote repository"
    echo "7. View Git status"
    echo "8. View Git log"
    echo "9. Switch to a different branch"
    echo "0. Exit"
    echo
}

# Function to read user input from the menu
read_input() {
    local choice
    read -p "Enter your choice: " choice
    echo

    case $choice in
        1) initialize_git_repo ;;
        2) configure_git_user ;;
        3) generate_ssh_key ;;
        4) read -p "Enter commit message: " commit_message
           add_and_commit "$commit_message" ;;
        5) push_changes ;;
        6) pull_changes ;;
        7) view_status ;;
        8) view_log ;;
        9) read -p "Enter branch name: " branch_name
           switch_branch "$branch_name" ;;
        0) exit ;;
        *) echo "Invalid choice." ;;
    esac
}

# Function to print the help message
print_help() {
    echo "Usage: $0 <command> [arguments]"
    echo "Commands:"
    echo "  init <remote-url>                  Initialize a new Git repository, commit 'init' on default branch 'main', and push changes"
    echo "  configure-user                     Configure Git user name, email, and default branch"
    echo "  generate-key                       Generate SSH key"
    echo "  menu                               Open interactive menu"
    echo "  -h, --help                         Show help"
    echo "  -v, --version                      Show version information"
}

# Function to print the version information
print_version() {
    echo "Git Productivity Script version 1.1"
}

# Check command-line arguments
if [[ $# -lt 1 ]]; then
    echo "Error: No command specified."
    echo "Use '$0 -h' or '$0 --help' for more information."
    exit 1
fi

# Process command-line arguments
case $1 in
    "init")
        if [[ -z $2 ]]; then
            echo "Please provide a remote repository URL."
            exit 1
        fi
        initialize_git_repo "$2"
        ;;
    "configure-user")
        configure_git_user
        ;;
    "generate-key")
        generate_ssh_key
        ;;
    "menu")
        while true; do
            print_menu
            read_input
            echo
        done
        ;;
    "-h" | "--help")
        print_help
        ;;
    "-v" | "--version")
        print_version
        ;;
    *) echo "Invalid command."
       echo "Use '$0 -h' or '$0 --help' for more information."
       exit 1
       ;;
esac
