#!/bin/bash

cd ~/dotfiles

# neobundleでvimプラグイン管理
mkdir -p ~/.vim/bundle
if [ ! -d ~/.vim/bundle/neobundle.vim ]; then
	git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
fi

# dotfileをホームディレクトリにリンク
DOT_FILES=(.vimrc .screenrc .gitignore .gitconfig .vimrc.bundle .vimrc.plugin_setting)

for file in ${DOT_FILES[@]}
do
	ln -sf ~/dotfiles/$file ~/$file
done

cd ~/
# phpマニュアルのダウンロード
if [ ! -d ~/docs/php-chunked-xhtml ]; then
	mkdir ~/docs && cd ~/docs
	wget -O php_manual_ja.tar.gz http://jp.php.net/get/php_manual_ja.tar.gz/from/this/mirror
	tar xzf php_manual_ja.tar.gz
	rm php_manual_ja.tar.gz
fi

# php辞書の作成
PHP_DICT=~/.vim/dict/php.dict
php -r '$f=get_defined_functions();echo join("\n", $f["internal"]);'|sort > PHP_DICT
#php -r 'echo join("\n", get_declared_classes());'|sort >> PHP_DICT
#php -r 'echo join("\n", get_declared_interfaces());'|sort >> PHP_DICT
#php -r 'echo join("\n", get_defined_constants());'|sort >> PHP_DICT

