
cd ~
ln -s dotfiles/zshrc .zshrc
ln -s dotfiles/tmux.conf .tmux.conf
ln -s dotfiles/vimrc .vimrc
ln -s dotfiles/fonts .fonts
ln -s dotfiles/Xresource .Xresource
ln -s dotfiles/Xmodmap .Xmodmap
ln -s dotfiles/lscolor .lscolor
ln -s dotfiles/lscolor256 .lscolor256
mkdir -p .vim/ftplugin
ln -s dotfiles/c.vim .vim/ftplugin/c.vim
ln -s dotfiles/python.vim .vim/ftplugin/python.vim

# powerline fonts
git clone https://github.com/powerline/fonts.git dotfiles/fonts/powerline/

# oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/oh-my-zsh
cp ~/dotfiles/piupiupiu.zsh-theme ~/oh-my-zsh/themes/
cp ~/dotfiles/piupiupiu.zsh ~/oh-my-zsh/custom/

# fasd
git clone https://github.com/clvv/fasd.git ~/fasd
cd ~/fasd && make install

# vundle for vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
