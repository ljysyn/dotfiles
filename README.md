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
git clone https://www.github.com/ljysyn/dotfiles.git
cd ~
ln -s dotfiles/.zshrc .zshrc
ln -s dotfiles/.tmux.conf .tmux.conf
ln -s dotfiles/.vimrc .vimrc
ln -s dotfiles/.fonts .fonts
ln -s dotfiles/.Xresource .Xresource
ln -s dotfiles/.Xmodmap .Xmodmap
ln -s dotfiles/.lscolor .lscolor
ln -s dotfiles/.lscolor256 .lscolor256
```

You need to install fasd:

```sh
cd ~
git clone https://www.github.com/clvv/fasd.git
cd fasd
maks install
```

## License

The GPL License
