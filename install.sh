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
	mkdir -p ~/docs && cd ~/docs
	# english
	wget -O php_manual.tar.gz http://jp.php.net/get/php_manual_en.tar.gz/from/this/mirror
	# japanese
	# wget -O php_manual.tar.gz http://jp.php.net/get/php_manual_ja.tar.gz/from/this/mirror
	tar xzf php_manual.tar.gz
	rm php_manual.tar.gz
fi

# php辞書の作成
PHP_DICT=~/.vim/dict/php.dict
# 関数
php -r '$f=get_defined_functions();echo join("\n", $f["internal"]);'|sort > $PHP_DICT
# クラス
php -r 'echo join("\n", get_declared_classes());'|sort >> $PHP_DICT
# インターフェース
php -r 'echo join("\n", get_declared_interfaces());'|sort >> $PHP_DICT
# 定数
php -r '$c=get_defined_constants();echo join("\n", array_keys($c));'|sort >> $PHP_DICT

