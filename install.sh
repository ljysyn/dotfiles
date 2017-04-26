
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
ln -s ~/dotfiles/c.vim .vim/ftplugin/c.vim
ln -s ~/dotfiles/python.vim .vim/ftplugin/python.vim

# powerline fonts
git clone https://github.com/powerline/fonts.git dotfiles/fonts/powerline/

# oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git dotfiles/oh-my-zsh
ln -s ~/dotfiles/piupiupiu.zsh-theme dotfiles/oh-my-zsh/themes/piupiupiu.zsh-theme
ln -s ~/dotfiles/piupiupiu.zsh dotfiles/oh-my-zsh/custom/piupiupiu.zsh

# fasd
git clone https://github.com/clvv/fasd.git dotfiles/fasd
cd dotfiles/fasd && make install && cd 

# vundle for vim
git clone https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
