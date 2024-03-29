## Quick Install Instructions
Paste the command below in a Mac OS Terminal:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/RobertDataWow/hii-setup-script/main/mac_setup.sh)"
```

## Post Installation Instructions
After you have run the script, please follow this steps:

**Fix ZSH Errors**\
If you are using ZSH as your shell (default in newer Mac OS versions) you may get this error after running the setup script:
 
> zsh compinit: insecure directories, run compaudit for list.\
> Ignore insecure directories and continue [y] or abort compinit [n]?

You can fix this by running the following command in your terminal:
```sh
compaudit | xargs chmod g-w
```


**Installing and Upgrading Node and NPM versions**\
There is a handy command in your `.bash_profile` and `.zsh_profile` that will automatically install your chosen version of Node and NPM, re-install any global npm packages (like angular cli), and set the newly installed version as default.
```sh
node-upgrade 20
```

If you wish to install a version of node without reinstalling all global packages or setting it to be default, you can use NVM directly ([Official docs][nvm docs]):
```sh
# Install a specific version of Node
nvm install 18      # or 10.10.0, 8.9.1, etc
```

<br>

**Switching Node Versions**\
Use nvm to switch between installed versions of Node. [Official docs][nvm docs]
```sh
# To switch to the latest Node
nvm use node        # "node" is an alias for the latest version

# Switch to long term support (lts) version of Node
nvm use --lts
 
# To switch to a specific verison of Node
nvm use 18          # or 10.10.0, 8.9.1, etc
```

[nvm docs]: https://github.com/nvm-sh/nvm/blob/master/README.md#usage

<br>
  
**Keeping your tools up-to-date**\
Homebrew can keep your command-line tools and languages up-to-date.
```sh
# List what needs to be updated
brew update
brew outdated
 
# Upgrade a specific app/formula (example: git)
brew upgrade git

# Upgrade everything
brew upgrade
  
# List previous versions installed (example: git)
brew switch git list
 
# Roll back to a currently installed previous version (example: git 2.25.0)
brew switch git 2.25.0
```


<br>
<br>

---