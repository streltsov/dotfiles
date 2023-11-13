#! /bin/bash

#######################
#######  LIGHT  #######
#######################

# System
# sed -i 's/-Dark//' .xsettingsd && xsettingsd & pkill xsettingsd

# Alacritty
PATH_TO_ALLACRITTY_CONF=~/.alacritty.yml
sed -i "$(wc -l < $PATH_TO_ALLACRITTY_CONF)s/dark/light/" $PATH_TO_ALLACRITTY_CONF

# Neovim
PATH_TO_NEOVIM_COLORSCHEME_FILE=~/.config/nvim/lua/min/colorscheme.lua
sed -i 's/vim\.o\.bg = "dark"/vim.o.bg = "light"/' $PATH_TO_NEOVIM_COLORSCHEME_FILE
# killall xmobar
# sed -i "s/^.*bgColor.*$/,bgColor = \"#f2e5bc\"/" ~/.xmobarrc
# sed -i "s/^.*fgColor.*$/,fgColor = \"#3c3836\"/" ~/.xmobarrc
# xmobar &
