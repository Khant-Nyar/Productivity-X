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
    if [[ -z $1 || -z $2 ]]; then
        echo "Please provide both user name and email."
    else
        git config --global user.name "$1"
        git config --global user.email "$2"
        echo "Git user configured: $1 <$2>"
    fi
}

# Function to configure SSH path for GitHub authentication
configure_git_ssh() {
    if [[ -z $1 ]]; then
        echo "Please provide the SSH path."
    else
        git config --global core.sshCommand "ssh -i $1"
        echo "Git SSH path configured: $1"
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

# Print help message
print_help() {
    echo "Usage: $0 <command> [arguments]"
    echo "Commands:"
    echo "  init <remote-url>                  Initialize a new Git repository, commit 'init' on default branch 'main', and push changes"
    echo "  configure-user <user-name> <email> Configure Git user name and email"
    echo "  configure-ssh <ssh-path>           Configure SSH path for GitHub authentication"
    echo "  add-commit <message>               Add and commit changes with a message"
    echo "  push                              Push changes to a remote repository"
    echo "  pull                              Pull changes from a remote repository"
    echo "  status                            View Git status"
    echo "  log                               View Git log"
    echo "  switch <branch-name>               Switch to a different branch"
    echo "  menu                              Open interactive menu"
    echo "  -h, --help                        Show help"
    echo "  -v, --version                     Show version information"
}

# Print version information
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
        configure_git_user "$2" "$3"
        ;;
    "configure-ssh")
        configure_git_ssh "$2"
        ;;
    "add-commit")
        add_and_commit "$2"
        ;;
    "push")
        push_changes
        ;;
    "pull")
        pull_changes
        ;;
    "status")
        view_status
        ;;
    "log")
        view_log
        ;;
    "switch")
        switch_branch "$2"
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
    *)
        echo "Invalid command."
        echo "Use '$0 -h' or '$0 --help' for more information."
        exit 1
        ;;
esac
