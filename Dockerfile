FROM ubuntu:19.04

# Dependencies
RUN apt update \
  && apt install -y curl wget git gnupg zsh sudo snapd locales

# User Setup
RUN useradd -u 1000 -d /home/kylecoberly -m -s /bin/zsh kylecoberly && echo "kylecoberly:kylecoberly" | chpasswd && adduser kylecoberly sudo && \
  chown -R kylecoberly:kylecoberly /home/kylecoberly && \
  echo 'kylecoberly ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

WORKDIR /home/kylecoberly
USER kylecoberly
ENV HOME /home/kylecoberly

RUN sudo locale-gen en_US.UTF-8

# Heroku Toolbelt & Oh-My-Zsh
RUN curl https://cli-assets.heroku.com/install.sh | sh && \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Ruby
RUN gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
    curl -sSL https://get.rvm.io | bash -s stable --rails
RUN /bin/bash -l -c "source .rvm/scripts/rvm" && \
    # sudo usermod -aG rvm kylecoberly && \
    /bin/bash -l -c "gem install pry"

# Node
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash && \
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    nvm install 12 && \
    nvm alias default $NODE_VERSION && \
    nvm use default && \
    npm i -g eslint knex mocha jest nodemon lite-server typescript yarn && \
    yarn global add ember-cli @vue/cli

# Packages
RUN sudo apt update && \
  sudo apt install -y iproute2 xclip tree nmap build-essential \
  ranger tmux fonts-powerline \
  neovim python-neovim python3-neovim

# Vim
COPY --chown=kylecoberly:kylecoberly ./dotfiles/init.vim $HOME/.config/nvim/init.vim
RUN nvim +PlugInstall +qall

# Theme
RUN sh -c "mv ${HOME}/dotfiles/dotfiles/coberly-agnoster.zsh-theme ${HOME}/.oh-my-zsh/themes/coberly-agnoster.zsh-theme"

ENTRYPOINT ["zsh", "-l"]
