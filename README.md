# dotfile

***

Dotfiles for some tools on ubuntu desktop:

zsh

tmux

xterm

fonts

xmodmap

fasd

vim

## Installation

Make sure you have installed zsh, tmux, vim.

You need to use XTERM as your terminal tools.

You should do this:

```sh
cd ~
mkdir dotfiles
cd dotfiles
git clone https://github.com/ljysyn/dotfiles.git
cd ~
ln -s dotfiles/.zshrc .zshrc
ln -s dotfiles/.tmux.conf .tmux.conf
ln -s dotfiles/.vimrc .vimrc
ln -s dotfiles/.fonts .fonts
ln -s dotfiles/.Xresource .Xresource
ln -s dotfiles/.Xmodmap .Xmodmap
ln -s dotfiles/.lscolor .lscolor
ln -s dotfiles/.lscolor256 .lscolor256
mkdir -p .vim/ftplugin
cd .vim/ftplugin
ln -s ../../dotfiles/c.vim c.vim
ln -s ../../dotfiles/python.vim python.vim
```

You need to install fasd:

```sh
cd ~
git clone https://github.com/clvv/fasd.git
cd fasd
maks install
```

The Vundle should be installed as VIM plugin manager:

```sh
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim
:BundleInstall
```

## License

The GPL License

