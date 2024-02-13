#!/bin/bash

# Path to store the profile configurations
config_file="$HOME/.git_profiles"

function add_profile() {
  # Check if config file already exists
  if [[ -f $config_file ]]; then
    echo "Profiles already exist. Do you want to override them? (y/n)"
    read -r override
    if [[ "$override" != "y" ]]; then
      echo "Using existing profiles."
      return
    fi
  fi

  # Prompt for work profile details
  echo "Enter work profile details:"
  read -p "Username: " work_name
  read -p "Email: " work_email
  read -p "SSH Host: " ssh_host_work

  # Prompt for personal profile details
  echo "Enter personal profile details:"
  read -p "Username: " personal_name
  read -p "Email: " personal_email
  read -p "SSH Host: " ssh_host_personal

  # Save profiles to config file
  echo "work_name=$work_name" > $config_file
  echo "work_email=$work_email" >> $config_file
  echo "ssh_host_work=$ssh_host_work" >> $config_file
  echo "personal_name=$personal_name" >> $config_file
  echo "personal_email=$personal_email" >> $config_file
  echo "ssh_host_personal=$ssh_host_personal" >> $config_file

  echo "Profiles added successfully."
}

function switch_profile() {
  # Check if profiles are set
  if [[ ! -f $config_file ]]; then
    echo "No profiles found. Please add git profile with 'add' command."
    exit 1
  fi

  # Load profiles
  source $config_file

  # Determine the current account based on Git config
  current_username=$(git config --global user.name)
  current_email=$(git config --global user.email)
  current_account=""
  if [[ "$current_username" == "$work_name" && "$current_email" == "$work_email" ]]; then
    current_account="work"
  elif [[ "$current_username" == "$personal_name" && "$current_email" == "$personal_email" ]]; then
    current_account="personal"
  fi

  # Highlight the current account using description
  options=$(for account in "work" "personal"; do
    if [[ "$account" == "$current_account" ]]; then
      echo "$account (current)"
    else
      echo "$account"
    fi
  done)

  # Use fzf to select account
  selected_account=$(echo -e "$options" | fzf --ansi)

  # Remove any annotations from the selection (e.g., " (current)")
  selected_account_cleaned=$(echo "$selected_account" | sed 's/ (current)//')

  # Assuming you're in a Git repository, fetch the current remote repository name
  current_remote_url=$(git remote get-url origin)
  # Extract the repository part of the URL (e.g., username/repo.git)
  echo ${current_remote_url}
  repo_part=$(echo "$current_remote_url" | sed -E 's/.*:(.+)/\1/')
  echo ${repo_part}

  case $selected_account_cleaned in
    work)
      selected_username="$work_name"
      selected_email="$work_email"
      selected_ssh_host="$ssh_host_work"
      # Update Git remote URL to use work account's SSH configuration
      git remote set-url origin "git@${ssh_host_work}:${repo_part}"
      ;;
    personal)
      selected_username="$personal_name"
      selected_email="$personal_email"
      selected_ssh_host="$ssh_host_personal"
      # Update Git remote URL to use personal account's SSH configuration
      git remote set-url origin "git@${ssh_host_personal}:${repo_part}"
      ;;
    *)
      echo "Invalid selection. Exiting."
      exit 1
      ;;
  esac

  # Set Git config for selected account
  git config --global user.name "$selected_username"
  git config --global user.email "$selected_email"

  echo "Switched to $selected_account_cleaned account ($selected_username)."
}

# Main script logic
case "$1" in
  add)
    add_profile
    ;;
  switch)
    switch_profile
    ;;
  *)
    switch_profile
    ;;
esac
