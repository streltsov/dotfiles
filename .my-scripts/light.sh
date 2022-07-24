#! /bin/bash

#######################
#######  LIGHT  #######
#######################

# Alacritty
PATH_TO_ALLACRITTY_CONF=~/.alacritty.yml
sed -i "$(wc -l < $PATH_TO_ALLACRITTY_CONF)s/dark/light/" $PATH_TO_ALLACRITTY_CONF

# Neovim
PATH_TO_NEOVIM_COLORSCHEME_FILE=~/.config/nvim/lua/min/colorscheme.lua
sed -i "$(wc -l < $PATH_TO_NEOVIM_COLORSCHEME_FILE)s/dark/light/" $PATH_TO_NEOVIM_COLORSCHEME_FILE

