dotfiles
========
git clone https://github.com/yamagu/dotfiles dotfiles
cd dotfiles
sh install.sh

vim
:NeoBundleInstall

cd ~/.vim/bundle/vimproc
make -f make_unix.mak
