#!/bin/bash

# Prompt for home directory name
# read -p "Enter the name of your home directory: " home_dir_name
# if [ -z "$home_dir_name" ]; then
#  echo "Home directory name cannot be empty. Exiting."
#  exit 1
# fi

# Update and upgrade packages
sudo apt update && sudo apt upgrade -y

# Install i3
echo "Installing i3........................................................................."
sudo apt install i3 -y

# Move i3 config to .config/i3/
echo "Copying i3config......................................................................"
if [ -f ./linux-setup/i3config ]; then
  mkdir -p ~/.config/i3/
  cp ./linux-setup/i3config ~/.config/i3/config
else
  echo "i3 config file not found. Skipping."
fi

# Install software
echo "Installing wget, git, htop, vim......................................................."
sudo apt install wget git htop vim curl php-cli unzip fd-find -y

# Install dev packages
# npm + node
echo "Installing npm........................................................................"
sudo apt install npm -y
sudo npm install npm -g

echo "Installing nvm........................................................................"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
nvm install --lts
nvm use --lts

# docker
echo "Installing docker....................................................................."
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo usermod -aG docker ${USER}

echo "Installing docker compose............................................................."
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.32.4/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

# yarn
sudo npm install -g yarn -y

# composer
echo "Installing composer..................................................................."
cd ~
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
cd ~/Downloads

# Chrome install
echo "Installing Chrome....................................................................."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt install -f -y  # Fix any dependency issues
rm google-chrome-stable_current_amd64.deb

# install bcompare
echo "Installing Chrome....................................................................."
wget https://www.scootersoftware.com/files/bcompare-4.4.7.28397_amd64.deb
sudo dpkg -i bcompare-4.4.7.28397_amd64.deb
sudo apt install -f -y  # Fix any dependency issues
rm bcompare-4.4.7.28397_amd64.deb

# sublime text install
echo "Installing Sublime Text..............................................................."
sudo snap install sublime-text --classic

# postman
echo "Installing Postman...................................................................."
sudo snap install postman

# vscode
echo "Installing VSCode....................................................................."
sudo snap install --classic code

# Download cursor
echo "Installing Cursor....................................................................."
sudo apt install libfuse2 -y

if [ -f ./install-cursor.sh ]; then
  ./install-cursor.sh
else
  echo "Cursor installation script not found. Skipping."
fi

# Install DBeaver
echo "Installing Dbeaver...................................................................."
wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
sudo dpkg -i dbeaver-ce_latest_amd64.deb
sudo apt install -f -y  # Fix any dependency issues
rm dbeaver-ce_latest_amd64.deb

# Install mysql workbench
echo "Installing MySQL Workbench............................................................"
wget https://downloads.mysql.com/archives/get/p/8/file/mysql-workbench-community_8.0.36-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-workbench-community_8.0.36-1ubuntu22.04_amd64.deb
sudo apt install -f -y  # Fix any dependency issues
rm mysql-workbench-community_8.0.36-1ubuntu22.04_amd64.deb

# Mouse Acceleration settings
echo "Mouse settings........................................................................"
sudo cp ./linux-setup/40-libinput.conf /etc/X11/xorg.conf.d/

# Setup keyboard detect and switch in i3
sudo cp ./linux-setup/detect_usb_keyboard.sh ~/.config/i3/
sudo cp ./linux-setup/switch_keyboard.sh ~/.config/i3/

# Add switcher into users home directory
sudo cp ./linux-setup/detect_usb_keyboard.sh ~/
sudo cp ./linux-setup/switch_keyboard.sh ~/

# Install Zsh and Oh My Zsh
echo "Installing zsh........................................................................"
sudo apt install zsh -y

echo "Installing oh my zsh.................................................................."
#sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
chmod +x install.sh
./install.sh
rm install.sh

# Show plugins to add on later
echo "Plugins to add on later:"
echo "https://ohmyz.sh/#install"

# Install Powerlevel10k theme
echo "Installing Poerlevel10k theme........................................................."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install plugins
# fzf
echo "Installing fzf........................................................................"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# zsh syntax hilighting
echo "Installing zsh syntax hilighting......................................................"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zsh
echo "Installing zsh autosuggestions........................................................"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Copy Zsh configuration
echo "Copying zsh configuration............................................................."
if [ -f ./linux-setup/zshrc_config ]; then
  cp ./linux-setup/zshrc_config ~/.zshrc   
  echo "Zsh configuration file copied successfully."
else
  echo "Zsh configuration file not found. Skipping."
fi

# Optional: Run p10k configure
read -p "Do you want to run 'p10k configure' now? (y/n): " run_p10k
if [ "$run_p10k" == "y" ]; then
  p10k configure
fi

echo ""
echo ""
echo "****************************************************SUMMARY********************************************"
echo ""
echo "OH MY ZSH PLUGINS:"
echo "https://ohmyz.sh/#install"
echo ""
echo "POWER LEVEL 10K DOCS:"
echo "https://github.com/romkatv/powerlevel10k"
echo ""
echo "NVM DOCS:"
echo "https://docs.npmjs.com/downloading-and-installing-node-js-and-npm"
echo "Install latest version by running the install.sh here -> https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating"
echo ""
echo "FZF CONFIGURATIONS:"
echo "https://www.linode.com/docs/guides/how-to-use-fzf/"
echo ""
echo "DOCKER INSTALLATION:"
echo "https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04"
echo ""
echo "DOCKER COMPOSE INSTALLATION:"
echo "https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-22-04"
echo ""
echo "****************************************************SUMMARY********************************************"
