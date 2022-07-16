#!/bin/bash

# Shell
OHMYZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "${OHMYZSH_DIR}" ]
then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Programs

sudo apt update

## Utilities

sudo apt install -y --no-install-recommends ranger bat htop ncdu nmap tldr tree wget

## Development

sudo apt install -y --no-install-recommends tmux neovim python3
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node
python3 -m pip --user --upgrade pynvim
# pip install pynvim

## Link Files

ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/coberly-gruvbox.zsh-theme $HOME/.oh-my-zsh/custom/themes
mkdir -p $HOME/.config/nvim && ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/init.vim $HOME/.config/nvim
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

DOTFILES=(.gitconfig .zshrc .aliases .tmux.conf .tmux.conf.local) 
for dotfile in $(echo ${DOTFILES[*]});
do
  ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/$(echo $dotfile) $HOME/$(echo $dotfile)
done
nvim --headless +PlugInstall +qall # First time for most plugin installs
nvim --headless +PlugInstall +qall # Second time to install CoC
nvim --headless +PlugInstall +qall # Second time to install CoC

echo "Environment setup complete" | wall
