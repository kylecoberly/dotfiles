# Kyle Coberly's dotfiles

## Installation

`./install` runs `install_apt_packages`, `install_node_global_packages`, and `symlink_dotfiles`.

## Scripts

### `install_crouton`

* Ubuntu 14.04
* Audio Support
* Chrome
* CLI tools
* Chrome Extension
* Chrome special key support
* Touch support
* Unity Desktop
* XFCE Desktop
* XBMC
* X.org

My default [crouton](https://github.com/dnschneid/crouton) configuration

### `install_apt_packages`

Includes:

* `curl`
* `git`
* `xclip`
* `tmux`
* `vim`
* `ranger`
* Full LAMP stack
* Mongo
* `zsh` (including oh-my-zsh)

### `install_node_global_packages`

Includes:

* `nvm`
* `node 0.12`
* `node` (latest)
* Ember CLI
* `bower`
* Express Generator
* `knex`
* `nodemon`

### `symlink_dotfiles`

Links up installed dotfiles:

* `.gitconfig`
* `.tmux`
* `.tmux.conf`
* `.bashrc`
* `.zshrc`
* `.vimrc`
* `.vim`
* `.jshintrc`

### Custom vim stuff:

#### Syntastic

Syntax-checks and style-checks JavaScript files on open and save

#### ctrlp

`Space-n` to do a fuzzy file search

#### Vim Commentary

`gcc` to comment out a line, `3gcc` to comment out 3 lines

#### Find/Replace

`Space-fr` to find/replace in the open file. Works within a selection also.
