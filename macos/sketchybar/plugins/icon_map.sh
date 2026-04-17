#!/bin/bash
# icon_map.sh — maps an aerospace app-name to a nerd-font glyph.
# Source this file to use `app_icon` in your plugin scripts.

app_icon() {
    local name="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
    case "$name" in
        *chrome*)                                echo "" ;;
        *firefox*)                               echo "" ;;
        *safari*)                                echo "" ;;
        *arc*)                                   echo "󰣇" ;;
        *brave*)                                 echo "󰖟" ;;
        *alacritty*)                             echo "" ;;
        *ghostty*|*iterm*|*wezterm*|*kitty*|*terminal*) echo "" ;;
        *code*|*visual*studio*)                  echo "󰨞" ;;
        *xcode*)                                 echo "" ;;
        *nvim*|*neovide*|*vim*)                  echo "" ;;
        *jetbrains*|*intellij*|*rubymine*|*webstorm*|*pycharm*|*goland*|*datagrip*) echo "" ;;
        *slack*)                                 echo "󰒱" ;;
        *discord*)                               echo "󰙯" ;;
        *zoom*)                                  echo "󰍫" ;;
        *teams*)                                 echo "󰊻" ;;
        *rambox*)                                echo "󰇱" ;;
        *telegram*)                              echo "" ;;
        *whatsapp*)                              echo "󰖣" ;;
        *messages*|*imessage*)                   echo "󰭹" ;;
        *mail*|*airmail*)                        echo "󰇮" ;;
        *notion*)                                echo "󰝮" ;;
        *obsidian*)                              echo "󰠮" ;;
        *spotify*)                               echo "" ;;
        *music*)                                 echo "" ;;
        *podcasts*)                              echo "" ;;
        *1password*|*password*)                  echo "󰌾" ;;
        *finder*)                                echo "󰀶" ;;
        *figma*)                                 echo "󰇣" ;;
        *sketch*)                                echo "" ;;
        *photoshop*)                             echo "" ;;
        *calendar*|*fantastical*|*ical*)         echo "" ;;
        *preview*)                               echo "" ;;
        *activity*monitor*)                      echo "" ;;
        *system*settings*|*system*preferences*)  echo "" ;;
        *karabiner*)                             echo "󰌌" ;;
        *claude*)                                echo "" ;;
        *chatgpt*|*openai*)                      echo "" ;;
        *focusrite*|*midi*control*)              echo "󰽰" ;;
        *) echo "󰘔" ;;
    esac
}

# Invoked directly (for quick debugging): print glyph for $1
[ "${BASH_SOURCE[0]}" = "$0" ] && app_icon "$1"
