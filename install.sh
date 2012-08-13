#!/bin/bash

mkdir -p ~/.vim/bundle
if [ ! -d ~/.vim/bundle/neobundle.vim ]; then
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
fi

DOT_FILES=(.vimrc .screenrc .gitignore .gitconfig .vimrc.bundle .vimrc.plugin_setting)

for file in ${DOT_FILES[@]}
do
    ln -sf $HOME/dotfiles/$file $HOME/$file
done
