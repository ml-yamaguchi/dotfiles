#!/bin/bash

DOT_FILES=(.vim .vimrc .screenrc .gitignore .gitconfig .gitmodules .vimrc.bundle .vimrc.plugin_setting)

for file in ${DOT_FILES[@]}
do
    ln -sf $HOME/dotfiles/$file $HOME/$file
done
