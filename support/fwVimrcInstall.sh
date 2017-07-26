#!/bin/bash
# @farwish.com BSD-License

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

git clone https://github.com/farwish/vimrc.git ~/vimrc

cp ~/vimrc/.vimrc ~/

# Contain .gitconfig
cp ~/vimrc/.gitconfig ~/

# Clear
rm -rf ~/vimrc

echo -e "\nDone! Execute command below.\n"

echo -e "$ vim"
echo -e "$ :PluginInstall\n"
