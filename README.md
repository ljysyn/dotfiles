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

```shell
git clone https://github.com/ljysyn/dotfiles.git ~/dotfiles
```

You need to install oh-my-zsh:

```shell
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/oh-my-zsh
cp ~/dotfiles/piupiupiu.zsh-theme ~/oh-my-zsh/themes/
cp ~/dotfiles/piupiupiu.zsh ~/oh-my-zsh/custom/
```

You need to install fasd:

```shell
git clone https://github.com/clvv/fasd.git ~/fasd
cd ~/fasd && make install
```

The Vundle should be installed as VIM plugin manager:

```shell
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim
:BundleInstall
```

## License

The GPL License

