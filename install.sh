
# How to build work station

sudo apt-get install zsh
sudo apt-get install tmux
sudo apt-get install vim-nox
sudo apt-get install cmake
sudo apt-get install git
sudo apt-get install subversion
sudo apt-get install python-dev
sudo apt-get install ruby
sudo apt-get install ruby-dev

cd ~

ln -s dotfiles/zshrc .zshrc
ln -s dotfiles/tmux.conf .tmux.conf
ln -s dotfiles/vimrc .vimrc
ln -s dotfiles/Xresource .Xresource
ln -s dotfiles/Xmodmap .Xmodmap
ln -s dotfiles/lscolor .lscolor
ln -s dotfiles/lscolor256 .lscolor256

mkdir -p .vim/ftplugin
ln -s ~/dotfiles/c.vim .vim/ftplugin/c.vim
ln -s ~/dotfiles/python.vim .vim/ftplugin/python.vim
ln -s ~/dotfiles/markdown.vim .vim/ftplugin/markdown.vim

# powerline fonts
mkdir fonts
git clone https://github.com/powerline/fonts.git ~/fonts/powerline/
~/fonts/powerline/install.sh
rm -rf fonts

# wqy fonts for chinese
font_dir="$HOME/.local/share/fonts"
cp ~/dotfiles/fonts/wqy/wqy-zenhei.ttc $font_dir 
cp ~/dotfiles/fonts/wqy/wqy-microhei.ttc $font_dir
fc-cache -f $font_dir

# oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/oh-my-zsh
ln -s ~/dotfiles/piupiupiu.zsh-theme ~/oh-my-zsh/themes/piupiupiu.zsh-theme
ln -s ~/dotfiles/piupiupiu.zsh ~/oh-my-zsh/custom/piupiupiu.zsh

# fasd
git clone https://github.com/clvv/fasd.git ~/fasd
cd ~/fasd && sudo make install && cd ~ && rm -rf fasd

# vundle for vim
git clone https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
vim +PluginInstall +qall

# YouCompleteMe install
cd ~/.vim/bundle/YouCompleteMe/ && ./install --clang-completer && cd ~

# command-t install
cd ~/.vim/bundle/command-t/ruby/command-t/ext/command-t && ruby extconf.rb && make && cd ~
