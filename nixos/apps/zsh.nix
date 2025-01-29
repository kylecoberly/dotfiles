{ config, osConfig, lib, pkgs, ... }:

{
  osConfig.environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh = {
    enable = true;

    history.size = 10000;

    enableCompletion = true;
    autoSuggestion.enable = true;

    syntaxHighlighting.enable = true;

    autocd.enable = true;

    initExtraFirst = "
# PATH
export PATH=\"/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin\"
export PATH=\"$HOME/.local/bin:$PATH\"
export PATH=\"/opt/local/bin:/opt/local/sbin:$PATH\"
export PATH=\"$PATH:/nix/var/nix/profiles/default/bin\"

# Search
bindkey '^R' history-incremental-search-backward # Search
setopt extendedglob nocaseglob globdots

# Vim Mode
bindkey -v # Enable vim mode
bindkey -M viins 'jj' vi-cmd-mode # Go to normal with jj
bindkey -M viins 'jk' vi-cmd-mode # Go to normal with jk

# Autocomplete
bindkey \"\e.\" insert-last-word

# Make and Move
function mkcd(){
    mkdir $1
    cd $1
}

# Tree one level down
function e(){
    tree -L $1
}

# Show other computers on network
function scan(){
    sudo nmap -sP `ip a | grep 'wlan0' | grep 'inet' | awk '{print $2}'`
}
    ";
    initExtra = "";

    shellAliases = {
      "c" = "clear";
      "lsa" = "ls -lAGhp --group-directories-first --color=always | awk '{print \$1,\$3,\$4,\$8}' | column -t";
      "ll" = "ls -lGhp --group-directories-first --color=always | awk '{print \$1,\$3,\$4,\$8}' | column -t";
      "cat" = "batcat";
      "ranger" = "'ranger --choosedir=$HOME/rangerdir; LASTDIR=`cat $HOME/rangerdir`; rm -f $HOME/rangerdir; cd \"$LASTDIR\"'";
      "vi" = "nvim";
      "vim" = "nvim";
      "open" = "xdg-open";
      "top" = "htop";
      "du"="ncdu --color dark -rr -x --exclude .git --exclude node_modules";
      "help" = "tldr";
      "update" = "sudo nixos-rebuild switch";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        ## Aliases and completion
        "aliases" # als command to list available aliases
        "common-aliases" # standard aliases
        "asdf" # Completion asdf language manager
        "aws" # awscli v2 completion
        "docker" # autocompletion and aliases for docker
        "docker-compose" # autocompletion and aliases for docker-compose
        "git" # aliases and functions
        "git-extras" # completion for extra commands
        "mongo-atlas" # completion for mongo-atlas
        "mongocli" # completion for mongo
        "node" # node docs links
        "npm" # completion and aliases
        "postgres" # aliases
        "ssh" # Complete from .ssh folder
        "snap" # aliases for Linux snap commands
        "ubuntu" # completions and aliases
        "history" # aliases
        "vscode" # Enable interaction between terminal and VS code
        "tmux" # aliases

        ## Interaction
        "vi-mode" # vi functionality
        "sudo" # Press ESC twice to prepend sudo to the current or previous command
        "fancy-ctrl-z" # Toggle focus of suspended jobs back and forth
        "copyfile" # copyfile command to copy file contents to clipboard
        "copypath" # copypath command to copy path to clipboard
        "thefuck" # command correction

        ## Services
        "1password"
        "ssh-agent" # Autostart ssh-agent

        ## Appearance
        "colorize" # syntax for many languages
        "emoji" # unicode support
        "colored-man-pages"
        "command-not-found" # suggestions from db for missing commands
      ];
      theme = "agnoster";
      extra-config = "
        DEFAULT_USER=kylecoberly
      ";
    };
    prezto = {
      enable = true;
      syntaxHighlighting = [
        "main"
        "brackets"
        "pattern"
        "line"
        "cursor"
        "root"
      ];
      terminal.autoTitle = true;
      tmux.autoStartLocal = true;
      tmux.autoStartRemote = true;
      utility.safeOps = true;
    };
    sessionVariables = {
    };
  };
}
