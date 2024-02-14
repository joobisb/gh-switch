# gh-switch

Simple script to switch between github acounts using [fzf](https://github.com/junegunn/fzf)

NB: Please note this is still a work in progress.

## How to use

1. Install [fzf](https://github.com/junegunn/fzf)
2. Installation
    - MacOS
        ```
        brew tap joobisb/gh-switch
        brew install gh-switch
        ```
    - Ubuntu
        - Clone the repository
        - Copy `switch.sh` to root directory
            - `cp switch.sh ~/.`
        - Set an alias in your shell configuration file (.zshrc/.bashrc)
            - `alias gh-switch="~/switch.sh"`
3. Set the ssh-keys for multiple accounts following this [gist](https://gist.github.com/oanhnn/80a89405ab9023894df7) following until Step 5 of the gist.
4. Set the git profiles by running the following command 
`gh-switch add`
    - This command will prompt to add the following for two git profiles
        - git username
        - git email
        - ssh host name set in Step 3
  
5. Run `gh-switch` command to switch between the git profiles

## Limitations
- Current version only support adding 2 git profiles.
- Currently the tool does not support its installation via any package manager for Ubuntu.