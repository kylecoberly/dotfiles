#!/bin/bash

#General
sudo apt-get update
sudo apt-get install -y curl git irssi nano xclip

#LAMP
sudo apt-get install -y apache2 mysql-server php5 libapache2-mod-php5
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

#tmux
sudo add-apt-repository ppa:pi-rho/dev
sudo apt-get update
sudo install -y tmux

#vim
sudo apt-get remove -y vim-tiny
sudo apt-get install vim

#Ranger
sudo apt-get install -y ranger caca-utils highlight atool w3m poppler-utils mediainfo

#Chrome
sudo apt-get install libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb

#Mongo
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get install -y mongodb-org

#nvm
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.24.1/install.sh | bash

#zsh
sudo apt-get install -y zsh git-core
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`
