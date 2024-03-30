#!/bin/bash

VERSION="v1"
#===============================================================================
#   A shell script to help with the quick setup and installation of tools and 
#   applications for Hii.
# 
#   Quick Instructions:
#
#   1. Make the script executable:
#      chmod +x ./mac_setup.sh
#
#   2. Run the script:
#      ./mac_setup.sh
#
#   3. Some installs will need your password
#
#   4. You will be promted to fill out your git email and name. 
#      Use the email and name you use for Github
#
#   5. Follow the Post Installation Instructions in the Readme:
README="https://github.com/RobertDataWow/hii-setup-script#post-installation-instructions"
#  
#===============================================================================

#===============================================================================
#  Functions
#===============================================================================


printHeading() {
    printf "\n\n\n\e[0;36m$1\e[0m \n"
}

printDivider() {
    printf %"$COLUMNS"s |tr " " "-"
    printf "\n"
}

printError() {
    printf "\n\e[1;31m"
    printf %"$COLUMNS"s |tr " " "-"
    if [ -z "$1" ]      # Is parameter #1 zero length?
    then
        printf "     There was an error ... somewhere\n"  # no parameter passed.
    else
        printf "\n     Error Installing $1\n" # parameter passed.
    fi
    printf %"$COLUMNS"s |tr " " "-"
    printf " \e[0m\n"
}

printStep() {
    printf %"$COLUMNS"s |tr " " "-"
    printf "\nInstalling $1...\n";
    $2 || printError "$1"
}

printLogo() {
cat << "EOT"
     __   _  ___  _    _ _ _  _  _ _ _ 
    |  \ / \|_ _|/ \  | | | |/ \| | | |
    | o ) o || || o | | V V ( o ) V V |
    |__/|_n_||_||_n_|  \_n_/ \_/ \_n_/ 
                                   
 ------------------------------------------
    Q U I C K   S E T U P   S C R I P T


    NOTE:
    You can exit the script at any time by
    pressing CONTROL+C a bunch
EOT
}

writetoBashProfile() {
cat << EOT >> ~/.bash_profile


# --------------------------------------------------------------------
# Begin Bash autogenerated content from mac_setup.sh   $VERSION
# --------------------------------------------------------------------

# Supress "Bash no longer supported" message
export BASH_SILENCE_DEPRECATION_WARNING=1

# Start Homebrew
if [[ "\$(uname -p)" == "arm" ]]; then
    # Apple Silicon M1/M2 Macs
    eval "\$(/opt/homebrew/bin/brew shellenv)"
else
    # Intel Macs
    eval "\$(/usr/local/bin/brew shellenv)"
fi

# Bash Autocompletion
if type brew &>/dev/null; then
  HOMEBREW_PREFIX="\$(brew --prefix)"
  if [[ -r "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "\${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "\$COMPLETION" ]] && source "\$COMPLETION"
    done
  fi
fi

# NVM
# This needs to be after "Setting up Path for Homebrew" to override Homebrew Node
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \
    source "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \
    source "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Node
# Increases the default memory limit for Node, so larger Angular projects can be built
export NODE_OPTIONS=--max_old_space_size=12000

# Update Node to selected version and reinstall previous packages
node-upgrade() {
    new_version=\${1:?"Please specify a version to upgrade to. Example: node-upgrade 20"}
    nvm install "\$new_version" --reinstall-packages-from=current
    nvm alias default "\$new_version"
    # nvm uninstall "\$prev_ver"
    nvm cache clear
}

# Vs Code
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# --------------------------------------------------------------------
# End autogenerated content from mac_setup.sh   $VERSION
# --------------------------------------------------------------------


EOT
}

writetoZshProfile() {
cat << EOT >> ~/.zprofile


# --------------------------------------------------------------------
# Begin ZSH autogenerated content from mac_setup.sh   $VERSION
# --------------------------------------------------------------------

# Start Homebrew
if [[ "\$(uname -p)" == "arm" ]]; then
    # Apple Silicon M1/M2 Macs
    eval "\$(/opt/homebrew/bin/brew shellenv)"
else
    # Intel Macs
    eval "\$(/usr/local/bin/brew shellenv)"
fi

# Brew Autocompletion
if type brew &>/dev/null; then
    fpath+=\$(brew --prefix)/share/zsh/site-functions
fi

# Zsh Autocompletion
# Note: must run after Brew Autocompletion
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
fpath=(/usr/local/share/zsh-completions \$fpath)


# NVM 
# This needs to be after "Setting up Path for Homebrew" to override Homebrew Node
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \
    source "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \
    source "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Node
# Increases the default memory limit for Node, so larger Angular projects can be built
export NODE_OPTIONS=--max_old_space_size=12000

# Update Node to selected version and reinstall previous packages
node-upgrade() {
    readonly new_version=\${1:?"Please specify a version to upgrade to. Example: node-upgrade 20"}
    nvm install "\$new_version" --reinstall-packages-from=current
    nvm alias default "\$new_version"
    # nvm uninstall "\$prev_ver"
    nvm cache clear
}

# Vs Code
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# --------------------------------------------------------------------
# End autogenerated content from mac_setup.sh   $VERSION
# --------------------------------------------------------------------


EOT
}

#===============================================================================
# Installer: Settings
#===============================================================================


# Show IDE Selection Menu
clear
printLogo
read -n 1 -r -s -p $'\n\nWhen ready press ANY KEY to continue...\n\n'
printDivider


#===============================================================================
#  Installer: Set up shell profiles
#===============================================================================


# Create .bash_profile and .zprofile if they dont exist
printHeading "Prep Bash and Zsh"
printDivider
    echo "✔ Touch ~/.bash_profile"
        touch ~/.bash_profile
printDivider
    echo "✔ Touch ~/.zprofile"
        touch ~/.zprofile
printDivider
    if grep --quiet "mac_setup.sh" ~/.bash_profile; then
        echo "✔ .bash_profile already modified. Skipping"
    else
        writetoBashProfile
        echo "✔ Added to .bash_profile"
    fi
printDivider
    # Zsh profile
    if grep --quiet "mac_setup.sh" ~/.zprofile; then
        echo "✔ .zprofile already modified. Skipping"
    else
        writetoZshProfile
        echo "✔ Added to .zprofile"
    fi
printDivider
    echo "(zsh) Rebuild zcompdump"
    rm -f ~/.zcompdump
printDivider


#===============================================================================
#  Installer: Main Payload
#===============================================================================


# Install xcode cli development tools
printHeading "Installing xcode cli development tools"
printDivider
    xcode-select --install && \
        read -n 1 -r -s -p $'\n\nWhen Xcode cli tools are installed, press ANY KEY to continue...\n\n' || \
            printDivider && echo "✔ Xcode cli tools already installed. Skipping"
printDivider


# Install Brew
printHeading "Installing Homebrew"
printDivider
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
printDivider
    echo "✔ Setting Path for Homebrew"
    echo "Path Before:"
    echo $PATH

    if [[ "$(uname -p)" == "arm" ]]; then
        # Apple Silicon M1/M2 Macs
        export PATH=/opt/homebrew/bin:$PATH
    else
        # Intel Macs
        export PATH=/usr/local/bin:$PATH
    fi
    
    echo "Path After:"
    echo $PATH
printDivider
    echo "✔ (zsh) Fix brew insecure directories warning"
    chmod go-w "$(brew --prefix)/share"
printDivider


# Install Utilities
printHeading "Installing Brew Packages"
    printStep "Bash"                        "brew install bash"
    printStep "bash-completion"             "brew install bash-completion"
    printStep "zsh-completions"             "brew install zsh-completions"
    printStep "Git"                         "brew install git"
printDivider



# Install  Apps
printHeading "Installing Applications"
#     if [[ -d "/Applications/Google Chrome.app" ]]; then
#         printDivider
#         echo "✔ Google Chrome already installed. Skipping"
#     else
#         printStep "Google Chrome"               "brew install --cask google-chrome"
#     fi

    if [[ -d "/Applications/Docker.app" ]]; then
        printDivider
        echo "✔ Docker already installed. Skipping"
    else
        printStep "Docker for Mac"                      "brew install --cask docker"
        printStep "Docker Compose for Mac"              "brew install docker-compose"
        mkdir -p ~/.docker/cli-plugins
        ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
    fi

#     if [[ -d "/Applications/Postico 2.app" ]]; then
#         printDivider
#         echo "✔ Postico already installed. Skipping"
#     else
#         printStep "Postico (DB Viewing)"                     "brew install --cask postico"
#     fi

#     if [[ -d "/Applications/Visual Studio Code.app" ]]; then
#         printDivider
#         echo "✔ Visual Studio Code already installed. Skipping"
#     else
#         printStep "Visual Studio Code (IDE)"                     "brew install --cask visual-studio-code"
#     fi
printDivider


# Install Node
printHeading "Installing Node and Yarn through NVM"
    printDivider
        getLastestNVM() {
            # From https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
            # Get latest release from GitHub api | Get tag line | Pluck JSON value
            curl --silent "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | 
                grep '"tag_name":' |
                sed -E 's/.*"([^"]+)".*/\1/'
        }
        echo "✔ Current NVM is $(getLastestNVM)"
    printDivider
        echo "Installing NVM (Node Version Manager) $(getLastestNVM)..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$(getLastestNVM)/install.sh | bash
    printDivider
        echo "✔ Loading NVM into PATH"
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    printDivider
        echo "Installing Node..."
        nvm install 20
    printStep "Yarn"                "npm install --location=global yarn"
printDivider



# Install System Tweaks
# printHeading "System Tweaks"
#     echo "✔ Finder: Show status bar and path bar"
#         defaults write com.apple.finder ShowStatusBar -bool true
#         defaults write com.apple.finder ShowPathbar -bool true
#     echo "✔ Finder: Show the ~/Library folder"
#         chflags nohidden ~/Library
#     printDivider
# printDivider



#===============================================================================
#  Setup Project
#===============================================================================


# Set up Project
BACKEND_DIR="$HOME/thaiwater/backend"
FRONTEND_DIR="$HOME/thaiwater/frontend"

printHeading "Setting Up Thaiwater Projects"
printDivider
      echo "✔ Clone Backend Repository"
      mkdir -p $BACKEND_DIR
      git clone https://git.hii.or.th/thaiwater-platform/thaiwatershare/backend.git $BACKEND_DIR
printDivider
      echo "✔ Clone Frontend Repository"
      mkdir -p $FRONTEND_DIR
      git clone https://git.hii.or.th/thaiwater-platform/thaiwatershare/FrontendMUI.git $FRONTEND_DIR


# Backend
printHeading "Setting Up Backend"
      cd $BACKEND_DIR
      cat .env.development > .env
printDivider
      echo "✔ Stopping All Brew Services"
      brew services stop --all
printDivider
      echo "✔ Checkout Main"
      git checkout origin/main
printDivider
      echo "✔ Install Dependencies"
      yarn install
printDivider
      echo "✔ Initializing Docker Image"
      docker-compose build
      docker-compose -f ./robot/docker-compose.yml build
printDivider
      echo "✔ Initializing Database"
      make up
      make reset-init-db

# Frontend
printHeading "Setting Up Frontend"
      cd $FRONTEND_DIR
printDivider
      echo "✔ Checkout Main"
      git checkout origin/main
printDivider
      echo "✔ Install Dependencies"
      yarn install

#===============================================================================
#  Installer: Complete
#===============================================================================

printHeading "Script Complete"
printDivider

tput setaf 2 # set text color to green
cat << "EOT"

   ╭─────────────────────────────────────────────────────────────────╮
   │░░░░░░░░░░░░░░░░░░░░░░░░░░░ Next Steps ░░░░░░░░░░░░░░░░░░░░░░░░░░│
   ├─────────────────────────────────────────────────────────────────┤
   │                                                                 │
   │   There are still a few steps you need to do to finish setup.   │
   │                                                                 │
   │        The link below has Post Installation Instructions        │
   │                                                                 │
   └─────────────────────────────────────────────────────────────────┘

EOT
tput sgr0 # reset text
echo "Link:"
echo $README
echo ""
echo ""
tput bold # bold text
read -n 1 -r -s -p $'             Press any key to to open the link in a browser...\n\n'
open $README
tput sgr0 # reset text

echo ""
echo ""
echo "Please open a new terminal window to continue your setup steps"
echo ""
echo ""


exit