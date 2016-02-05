#!/bin/bash

cd ~/dotfiles

# neobundleでvimプラグイン管理
mkdir -p ~/.vim/bundle
if [ ! -d ~/.vim/bundle/neobundle.vim ]; then
	git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
fi

# dotfileをホームディレクトリにリンク
DOT_FILES=(.zshrc .vimrc .gitignore .gitconfig .vimrc.bundle .vimrc.plugin_setting .tmux.conf)

for file in ${DOT_FILES[@]}
do
	ln -sf ~/dotfiles/$file ~/$file
done

