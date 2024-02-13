# gh-switch

Simple script to switch between github acounts using [fzf](https://github.com/junegunn/fzf)

NB: Please note this is still a work in progress.

## How to use

1. Clone the repository
2. Install [fzf](https://github.com/junegunn/fzf)
3. Set the ssh-keys for multiple accounts following this [gist](https://gist.github.com/oanhnn/80a89405ab9023894df7)
4. Set the git profiles by running the following command 
`bash script.sh add`
    - This command will prompt to add the following
        - git username
        - git email
        - ssh host name set by using Step 2
  
5. Run `bash script.sh` script to switch between the git profiles

## Limitations
- Current version only support adding 2 git profiles.