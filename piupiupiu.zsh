# You can put files here to add functionality separated per file, which
# will be ignored by git.
# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

# For example: add yourself some shortcuts to projects you often work on.
#
# brainstormr=~/Projects/development/planetargon/brainstormr
# cd $brainstormr
#

alias sw32="sudo mount --bind /home/liu/1-work/32bits/code /home/liu/1-work/32bits/compile/home/liu/code; sudo chroot /home/liu/1-work/32bits/compile /bin/bash -c \"su - liu\""
alias sw64="sudo mount --bind /home/liu/1-work/64bits/code /home/liu/1-work/64bits/compile/home/liu/code; sudo chroot /home/liu/1-work/64bits/compile /bin/bash -c \"su - liu\""

alias com="sudo minicom -R utf-8 -w"


alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selectionlias zz='fasd_cd -d -i' # cd with interactive selection
alias v='f -e vim' # quick opening files with vim

# {{{ double ESC to prepend "sudo"
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    [[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
    zle end-of-line                 #光标移动到行末
}
zle -N sudo-command-line
#定义快捷键为： [Esc] [Esc]
bindkey "\e\e" sudo-command-line
# }}}

sss () { ssh -l root $1; }

if [[ -n $SSH_CONNECTION ]]; then
    function title()
    {
	    TERM=xterm
    }
else
    case $TERM in
        xterm*|rxvt*)
            function title() { print -nP "\e]0;$1\a" }
            ;;
        screen*)
            if [[ -n $STY ]] && (screen -ls |grep $STY &>/dev/null); then
                function title()
                {
                    #modify screen title
                    print -nP "\ek$1\e\\"
                    #modify window title bar
                    #print -nPR $'\033]0;'$2$'\a'
                }
            elif [[ -n $TMUX ]]; then       # actually in tmux !
                function title()
                {
                    #print -nP "\e]2;$1\a"
                    print -nP "\e]2;$1\a"
                }
            else
                # fallback
                function title() { print -nP "\ek$1\e\\" }
            fi
            ;;
        *)
            function title() {}
            ;;
    esac
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export EDITOR='vim'
eval "$(fasd --init auto)"
