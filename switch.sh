#!/bin/bash

# Define account details
work_name=""
work_email=""
personal_name=""
personal_email=""

# Define SSH Host configuration names from ~/.ssh/config
ssh_host_work="github.com"
ssh_host_personal="github-personal"

# Get current global Git username and email
current_username=$(git config --global user.name)
current_email=$(git config --global user.email)

# Determine the current account based on Git config
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
    # Update Git remote URL to use work account's SSH configuration
    git remote set-url origin "git@${ssh_host_work}:${repo_part}"
    ;;
  personal)
    selected_username="$personal_name"
    selected_email="$personal_email"
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

echo "Switched to $selected_account_cleaned account ($selected_username). Git remote URL updated."
