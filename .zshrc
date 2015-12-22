#!/bin/zsh
# vim:fdm=marker

# 预配置 {{{
# 如果不是交互shell就直接结束 (unix power tool, 2.11)
#if [[  "$-" != *i* ]]; then return 0; fi

# 为兼容旧版本定义 is-at-least 函数
function is-at-least {
    local IFS=".-" min_cnt=0 ver_cnt=0 part min_ver version

    min_ver=(${=1})
    version=(${=2:-$ZSH_VERSION} 0)

    while (( $min_cnt <= ${#min_ver} )); do
      while [[ "$part" != <-> ]]; do
	(( ++ver_cnt > ${#version} )) && return 0
	part=${version[ver_cnt]##*[^0-9]}
      done

      while true; do
	(( ++min_cnt > ${#min_ver} )) && return 0
	[[ ${min_ver[min_cnt]} = <-> ]] && break
      done

      (( part > min_ver[min_cnt] )) && return 0
      (( part < min_ver[min_cnt] )) && return 1
      part=''
    done
}

SHELL=`which zsh`

# 定义颜色 {{{
if [[ ("$TERM" = *256color || "$TERM" = screen*) && -f $HOME/.lscolor256 ]]; then
    #use prefefined colors
    eval $(dircolors -b $HOME/.lscolor256)
    use_256color=1
    export TERMCAP=${TERMCAP/Co\#8/Co\#256}
else
    [[ -f $HOME/.lscolor ]] && eval $(dircolors -b $HOME/.lscolor)
fi

#color defined for prompts and etc
autoload colors
[[ $terminfo[colors] -ge 8 ]] && colors
pR="%{$reset_color%}%u%b" pB="%B" pU="%U"
for i in red green blue yellow magenta cyan white black; {eval pfg_$i="%{$fg[$i]%}" pbg_$i="%{$bg[$i]%}"}
#}}}
#}}}

# 设置参数 {{{
setopt complete_aliases         #do not expand aliases _before_ completion has finished
setopt auto_cd                  # if not a command, try to cd to it.
setopt auto_pushd               # automatically pushd directories on dirstack
setopt auto_continue            #automatically send SIGCON to disowned jobs
setopt extended_glob            # so that patterns like ^() *~() ()# can be used
setopt pushd_ignore_dups        # do not push dups on stack
setopt pushd_silent             # be quiet about pushds and popds
setopt brace_ccl                # expand alphabetic brace expressions
#setopt chase_links             # ~/ln -> /; cd ln; pwd -> /
setopt complete_in_word         # stays where it is and completion is done from both ends
setopt correct                  # spell check for commands only
#setopt equals extended_glob    # use extra globbing operators
setopt no_hist_beep             # don not beep on history expansion errors
setopt hash_list_all            # search all paths before command completion
setopt hist_ignore_all_dups     # when runing a command several times, only store one
setopt hist_reduce_blanks       # reduce whitespace in history
setopt hist_ignore_space        # do not remember commands starting with space
setopt share_history            # share history among sessions
setopt hist_verify              # reload full command when runing from history
setopt hist_expire_dups_first   #remove dups when max size reached
setopt interactive_comments     # comments in history
setopt list_types               # show ls -F style marks in file completion
setopt long_list_jobs           # show pid in bg job list
setopt numeric_glob_sort        # when globbing numbered files, use real counting
setopt inc_append_history       # append to history once executed
setopt prompt_subst             # prompt more dynamic, allow function in prompt
setopt nonomatch

#remove / and . from WORDCHARS to allow alt-backspace to delete word
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

#report to me when people login/logout
watch=(notme)
#replace the default beep with a message
#ZBEEP="\e[?5h\e[?5l"        # visual beep

#is-at-least 4.3.0 && 

# 自动加载自定义函数
fpath=($HOME/.zfunctions $fpath)
# 需要设置了extended_glob才能glob到所有的函数，为了补全能用，又需要放在compinit前面
_my_functions=${fpath[1]}/*(N-.x:t)
[[ -n $_my_functions ]] && autoload -U $_my_functions

autoload -U is-at-least
# }}}

# 命令补全参数{{{
#   zsytle ':completion:*:completer:context or command:argument:tag'
zmodload -i zsh/complist        # for menu-list completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" "ma=${${use_256color+1;7;38;5;143}:-1;7;33}"
#ignore list in completion
zstyle ':completion:*' ignore-parents parent pwd directory
#menu selection in completion
zstyle ':completion:*' menu select=2
#zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _match #_user_expand
zstyle ':completion:*:match:*' original only 
#zstyle ':completion:*' user-expand _pinyin
zstyle ':completion:*:approximate:*' max-errors 1 numeric 
## case-insensitive (uppercase from lowercase) completion
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
### case-insensitive (all) completion
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER' 
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=1;31"
#use cache to speed up pacman completion
zstyle ':completion::complete:*' use-cache on
#zstyle ':completion::complete:*' cache-path .zcache 
#group matches and descriptions
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[33m == \e[1;7;36m %d \e[m\e[33m ==\e[m' 
zstyle ':completion:*:messages' format $'\e[33m == \e[1;7;36m %d \e[m\e[0;33m ==\e[m'
zstyle ':completion:*:warnings' format $'\e[33m == \e[1;7;31m No Matches Found \e[m\e[0;33m ==\e[m' 
zstyle ':completion:*:corrections' format $'\e[33m == \e[1;7;37m %d (errors: %e) \e[m\e[0;33m ==\e[m'
# dabbrev for zsh!! M-/ M-,
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes select

#autoload -U compinit
autoload -Uz compinit
compinit

#force rehash when command not found
#  http://zshwiki.org/home/examples/compsys/general
_force_rehash() {
    (( CURRENT == 1 )) && rehash
    return 1    # Because we did not really complete anything
}

# }}}

# 自定义函数 {{{

# 普通自定义函数 {{{
#show 256 color tab
256tab() {
    for k in `seq 0 1`;do 
        for j in `seq $((16+k*18)) 36 $((196+k*18))`;do 
            for i in `seq $j $((j+17))`; do 
                printf "\e[01;$1;38;5;%sm%4s" $i $i;
            done;echo;
        done;
    done
}

#alarm using atd
alarm() { 
    echo "msg ${argv[2,-1]} && aplay -q ~/.sounds/MACSound/System\ Notifi.wav" | at now + $1 min
}

#calculator
calc()  { awk "BEGIN{ print $* }" ; }

#check if a binary exists in path
bin-exist() {[[ -n ${commands[$1]} ]]}

# use stat_cal to generate github style commit log
(bin-exist stat_cal) && \
    git_cal_view() {
        pwd=$PWD
        for i in $*; do
            cd $i
            git log --no-merges --pretty=format:"%ai" --since="13 months"
            echo    # an "\n" is missing at the end of git log command
        done \
            |awk '{ a[$1] ++ }; END {for (i in a) {print i " " a[i]}}' \
            |sort \
            |stat_cal -s $COLUMNS
        cd $pwd
    }


#recalculate track db gain with mp3gain
(bin-exist mp3gain) && id3gain() { find $* -type f -iregex ".*\(mp3\|ogg\|wma\)" -exec mp3gain -r -s i {} \; }

#ccze for log viewing
(bin-exist ccze) && lless() { tac $* |ccze -A |less }

#man page to pdf
(bin-exist ps2pdf) && man2pdf() {  man -t ${1:?Specify man as arg} | ps2pdf -dCompatibility=1.3 - - > ${1}.pdf; }

#help command for builtins
help() { man zshbuiltins | sed -ne "/^       $1 /,/^\$/{s/       //; p}"}

(bin-exist ffmpeg) && extract_mp3() { ffmpeg -i $1 -acodec libmp3lame -metadata TITLE="$2" ${2// /_}.mp3 }

# }}}

#{{{ functions to set prompt pwd color
__PROMPT_PWD="$pfg_magenta%~$pR"
#change PWD color
pwd_color_chpwd() { [ $PWD = $OLDPWD ] || __PROMPT_PWD="$pU$pfg_cyan%~$pR" }
#change back before next command
pwd_color_preexec() { __PROMPT_PWD="$pfg_magenta%~$pR" }

#}}}

#{{{functions to display git branch in prompt

get_git_status() {
    unset __CURRENT_GIT_BRANCH
    unset __CURRENT_GIT_BRANCH_STATUS
    unset __CURRENT_GIT_BRANCH_IS_DIRTY

    # do not track git branch info in ~
    [[ "$PWD" = "$HOME" ]]  &&  return
    local dir=$(git rev-parse --git-dir 2>/dev/null)
    [[ "${dir:h}" = "$HOME" ]] && return

    local st="$(git status 2>/dev/null)"
    if [[ -n "$st" ]]; then
        local -a arr
        arr=(${(f)st})

        if [[ $arr[1] =~ 'Not currently on any branch.' ]]; then
            __CURRENT_GIT_BRANCH='no-branch'
        else
            __CURRENT_GIT_BRANCH="${arr[1][(w)4]}";
        fi

        if [[ $arr[2] =~ 'Your branch is' ]]; then
            if [[ $arr[2] =~ 'ahead' ]]; then
                __CURRENT_GIT_BRANCH_STATUS='ahead'
            elif [[ $arr[2] =~ 'diverged' ]]; then
                __CURRENT_GIT_BRANCH_STATUS='diverged'
            else
                __CURRENT_GIT_BRANCH_STATUS='behind'
            fi
        fi

        [[ ! $st =~ "nothing to commit" ]] && __CURRENT_GIT_BRANCH_IS_DIRTY='1'
    fi
}

git_branch_precmd() { [[ "$(fc -l -1)" == *git* ]] && get_git_status }

git_branch_chpwd() { get_git_status }

#this one is to be used in prompt
get_prompt_git() {
    if [[ -n $__CURRENT_GIT_BRANCH ]]; then
        local s=$__CURRENT_GIT_BRANCH
        case "$__CURRENT_GIT_BRANCH_STATUS" in
            ahead) s+="${pfg_green}+" ;;
            diverged) s+="${pfg_red}=" ;;
            behind) s+="${pfg_magenta}-" ;;
        esac
        [[ $__CURRENT_GIT_BRANCH_IS_DIRTY = '1' ]] && s+="${pfg_blue}*"
        echo " $pfg_black$pbg_white$pB $s $pR"
    fi
}
#}}}

#{{{ functions to set gnu screen title
# active command as title in terminals
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

#set screen title if not connected remotely
#if [ "$STY" != "" ]; then
screen_precmd() {
    #a bell, urgent notification trigger
    #echo -ne '\a'
    #title "`print -Pn "%~" | sed "s:\([~/][^/]*\)/.*/:\1...:"`" "$TERM $PWD"
    title "`print -Pn "%~" |sed "s:\([~/][^/]*\)/.*/:\1...:;s:\([^-]*-[^-]*\)-.*:\1:"`" "$TERM $PWD"
    echo -ne '\033[?17;0;127c'
}

screen_preexec() {
    local -a cmd; cmd=(${(z)1})
    case $cmd[1]:t in
        'ssh')          title "@""`echo $cmd[2]|sed 's:.*@::'`" "$TERM $cmd";;
        'sudo')         title "#"$cmd[2]:t "$TERM $cmd[3,-1]";;
        'for')          title "()"$cmd[7] "$TERM $cmd";;
        'svn'|'git')    title "$cmd[1,2]" "$TERM $cmd";;
        'ls'|'ll')      ;;
        *)              title $cmd[1]:t "$TERM $cmd[2,-1]";;
    esac
}

#}}}

#{{{define magic function arrays
if ! (is-at-least 4.3); then
    #the following solution should work on older version <4.3 of zsh. 
    #The "function" keyword is essential for it to work with the old zsh.
    #NOTE these function fails dynamic screen title, not sure why
    #CentOS stinks.
    function precmd() {
        screen_precmd 
        git_branch_precmd
    }

    function preexec() {
        screen_preexec
        pwd_color_preexec
    }

    function chpwd() {
        pwd_color_chpwd
        git_branch_chpwd
    }
else
    #this works with zsh 4.3.*, will remove the above ones when possible
    typeset -ga preexec_functions precmd_functions chpwd_functions
    precmd_functions+=screen_precmd
    precmd_functions+=git_branch_precmd
    preexec_functions+=screen_preexec
    preexec_functions+=pwd_color_preexec
    chpwd_functions+=pwd_color_chpwd
    chpwd_functions+=git_branch_chpwd
fi

#}}}

# }}}

# 提示符 {{{
if [ "$SSH_TTY" = "" ]; then
    local host="$pB$pfg_magenta%m$pR"
else
    local host="$pB$pfg_red%m$pR"
fi
local user="$pB%(!:$pfg_red:$pfg_green)%n$pR"       #different color for privileged sessions
local symbol="$pB%(!:$pfg_red# :$pfg_yellow$ )$pR"
local job="%1(j,$pfg_red:$pfg_blue%j,)$pR"
PROMPT='$user$pfg_yellow @ $pR$__PROMPT_PWD$job $symbol'
PROMPT2="$PROMPT$pfg_cyan%_$pR $pB$pfg_black>$pR$pfg_green>$pB$pfg_green>$pR "
#NOTE  **DO NOT** use double quote , it does not work
typeset -A altchar
set -A altchar ${(s..)terminfo[acsc]}
PR_SET_CHARSET="%{$terminfo[enacs]%}"
PR_SHIFT_IN="%{$terminfo[smacs]%}"
PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
#PR_RSEP=$PR_SET_CHARSET$PR_SHIFT_IN${altchar[\`]:-|}$PR_SHIFT_OUT
local prompt_time="%(?:$pfg_green:$pfg_red)%*$pR"
#RPROMPT='$__PROMPT_PWD'

# SPROMPT - the spelling prompt
SPROMPT="${pfg_yellow}zsh$pR: correct '$pfg_red$pB%R$pR' to '$pfg_green$pB%r$pR' ? ([${pfg_cyan}Y$pR]es/[${pfg_cyan}N$pR]o/[${pfg_cyan}E$pR]dit/[${pfg_cyan}A$pR]bort) "

#行编辑高亮模式 {{{
if (is-at-least 4.3); then
    zle_highlight=(region:bg=magenta
                   special:bold,fg=magenta
                   default:bold
                   isearch:underline
                   )
fi
#}}}

# }}}

# 键盘定义及键绑定 {{{
#bindkey "\M-v" "\`xclip -o\`\M-\C-e\""
# 设置键盘 {{{
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
autoload -U zkbd
bindkey -e      #use emacs style keybindings :(
typeset -A key  #define an array

#if zkbd definition exists, use defined keys instead
if [[ -f ~/.zkbd/${TERM}-${DISPLAY:-$VENDOR-$OSTYPE} ]]; then
    source ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}
else
    key[Home]=${terminfo[khome]}
    key[End]=${terminfo[kend]}
    key[Insert]=${terminfo[kich1]}
    key[Delete]=${terminfo[kdch1]}
    key[Up]=${terminfo[kcuu1]}
    key[Down]=${terminfo[kcud1]}
    key[Left]=${terminfo[kcub1]}
    key[Right]=${terminfo[kcuf1]}
    key[PageUp]=${terminfo[kpp]}
    key[PageDown]=${terminfo[knp]}
    for k in ${(k)key} ; do
        # $terminfo[] entries are weird in ncurses application mode...
        [[ ${key[$k]} == $'\eO'* ]] && key[$k]=${key[$k]/O/[}
    done
fi

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# }}}

# 键绑定  {{{ 
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "" history-beginning-search-backward-end
bindkey "" history-beginning-search-forward-end
bindkey -M viins "" history-beginning-search-backward-end
bindkey -M viins "" history-beginning-search-forward-end
bindkey '[1;5D' backward-word     # C-left
bindkey '[1;5C' forward-word      # C-right

autoload -U edit-command-line
zle -N      edit-command-line
bindkey '\ee' edit-command-line
# }}}

# }}}

# ZLE 自定义widget {{{
#

# {{{ pressing TAB in an empty command makes a cd command with completion list 
# from linuxtoy.org 
dumb-cd(){
    if [[ -n $BUFFER ]] ; then # 如果该行有内容
        zle expand-or-complete # 执行 TAB 原来的功能
    else # 如果没有
        BUFFER="cd " # 填入 cd（空格）
        zle end-of-line # 这时光标在行首，移动到行末
        zle expand-or-complete # 执行 TAB 原来的功能
    fi 
}
zle -N dumb-cd
bindkey "\t" dumb-cd #将上面的功能绑定到 TAB 键
# }}}

# {{{ colorize commands
TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'do' 'time' 'strace')

recolor-cmd() {
    region_highlight=()
    colorize=true
    start_pos=0
    for arg in ${(z)BUFFER}; do
        ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]## #}}))
        ((end_pos=$start_pos+${#arg}))
        if $colorize; then
            colorize=false
            res=$(LC_ALL=C builtin type $arg 2>/dev/null)
            case $res in
                *'reserved word'*)   style="fg=magenta,bold";;
                *'alias for'*)       style="fg=cyan,bold";;
                *'shell builtin'*)   style="fg=yellow,bold";;
                *'shell function'*)  style='fg=green,bold';;
                *"$arg is"*)         
                    [[ $arg = 'sudo' ]] && style="fg=red,bold" || style="fg=blue,bold";;
                *)                   style='none,bold';;
            esac
            region_highlight+=("$start_pos $end_pos $style")
        fi
        [[ ${${TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]}:+yes} = 'yes' ]] && colorize=true
        start_pos=$end_pos
    done
}

check-cmd-self-insert() { zle .self-insert && recolor-cmd }
check-cmd-backward-delete-char() { zle .backward-delete-char && recolor-cmd }

zle -N self-insert check-cmd-self-insert
zle -N backward-delete-char check-cmd-backward-delete-char
# }}}

# 拼音补全
function _pinyin() { reply=($($HOME/bin/chsdir 0 $*)) }

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

# {{{ c-z to continue
bindkey -s "" "fg\n"
# }}}

# {{{ esc-enter to run program in screen split region
function run-command-in-split-screen() {
    screen -X eval \
        "focus bottom" \
        split \
        "focus bottom" \
        "screen $HOME/bin/screen_run $BUFFER" \
        "focus top"
    zle kill-buffer
}
zle -N run-command-in-split-screen
bindkey "\e\r" run-command-in-split-screen
# }}}

# }}}

# 环境变量及其他参数 {{{
# number of lines kept in history
export HISTSIZE=10000
# number of lines saved in the history after logout
export SAVEHIST=10000
# location of history
export HISTFILE=$HOME/.zsh_history

export PATH=$PATH:$HOME/bin
export EDITOR=vim
export VISUAL=vim
export SUDO_PROMPT=$'[\e[31;5msudo\e[m] password for \e[33;1m%p\e[m: '
export INPUTRC=$HOME/.inputrc

export GOPATH=${HOME}/Works/code/golang
export PATH=${PATH}:${HOME}/.bin:${GOPATH}/bin

# for arm tools
export PATH=$PATH:$HOME/Data/compile/cross/EmbeddedArm/gcc-arm-none-eabi-4_9-2015q1/bin:$HOME/Data/compile/cross/EmbeddedArm/stlink

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

#MOST like colored man pages
export PAGER=less
export LESS_TERMCAP_md=$'\E[1;31m'      #bold1
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_me=$'\E[m'
export LESS_TERMCAP_so=$'\E[01;7;34m'  #search highlight
export LESS_TERMCAP_se=$'\E[m'
export LESS_TERMCAP_us=$'\E[1;2;32m'    #bold2
export LESS_TERMCAP_ue=$'\E[m'
export LESS="-M -i -R --shift 5"
export LESSCHARSET=utf-8
export READNULLCMD=less
# In archlinux the pipe script is in PATH, how ever in debian it is not
(bin-exist src-hilite-lesspipe.sh) && export LESSOPEN="| src-hilite-lesspipe.sh %s"
[ -x /usr/share/source-highlight/src-hilite-lesspipe.sh ] && export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"

#for ConTeX
#source $HOME/.context_env /home/roylez/soft/ConTeXt/tex

#for gnuplot, avoid locate!!!
#export GDFONTPATH=$(dirname `locate DejaVuSans.ttf | tail -1`)
[[ -n $DISPLAY ]] && export GDFONTPATH=/usr/share/fonts/TTF

# redefine command not found
(bin-exist cowsay) && (bin-exist fortune) && command_not_found_handler() { fortune -s| cowsay -W 70}

# }}}

# 读入其他配置 {{{ 

# 主机特定的配置，前置的主要原因是有可能需要提前设置PATH等环境变量
#   例如在aix主机，需要把 /usr/linux/bin
#   置于PATH最前以便下面的配置所调用的命令是linux的版本
[[ -f $HOME/.zshrc.$HOST ]] && source $HOME/.zshrc.$HOST
[[ -f $HOME/.zshrc.local ]] && source $HOME/.zshrc.local
##[[ -f $HOME/.incr.zsh ]] && source $HOME/.incr.zsh
source $HOME/.profile
# }}}

# 命令别名 {{{
# alias and listing colors
#
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selectionlias zz='fasd_cd -d -i' # cd with interactive selection
alias v='f -e vim' # quick opening files with vim

alias unzip="unzip -O CP936"
alias et="emacsclient -t"
#alias vi="et"
alias emacs="emacs -nw"
#alias e=emacs -q --no-splash --eval="(setq light-weight-emacs t)" -l "$HOME/.emacs.d/init.el"
#alias e=emacs -q --no-splash --eval="(setq light-weight-emacs t)" -l "$HOME/.emacs.d/init.el"
alias viewpic="feh -F -Z"
alias vgaon="xrandr --output VGA1 --right-of LVDS1 --auto"
alias vgaon2="xrandr --output VGA1 --same-as LVDS1 --mode 1024x768  "
alias tyon="sed -i 's/gap_x 850/gap_x 500/g' .conkyrc && xrandr --output LVDS1 --mode 1024x768 && xrandr --output VGA1 --same-as LVDS1 --mode 1024x768  "
alias tyoff="xrandr --output VGA1 --off && sed -i 's/gap_x 500/gap_x 850/g' .conkyrc && xrandr -s 0"
alias vgaonl="xrandr --output VGA1 --left-of LVDS1 --auto"
alias vgaoff="xrandr --output VGA1 --off"
alias 993="sudo ip addr add 192.168.99.3/24 dev eth0; sudo ip link set dev eth0 up"
alias h2o="sudo netctl stop mywifi; sudo netctl start openwrt"
alias o2w="sudo netctl stop openwrt; sudo netctl start workwifi"
alias w2o="sudo netctl stop workwifi; sudo netctl start openwrt"
alias cls='printf %b '\"\033c'\"'
# Set up auto extension stuff
alias -s html=$BROWSER
alias -s org=$BROWSER
alias -s php=$BROWSER
alias -s com=$BROWSER
alias -s net=$BROWSER
alias -s pdf=evince
alias -s sxw=soffice
alias -s doc=wps
alias -s docs=wps
alias -s xls=et
alias -s xlss=et
alias -s gz=tar zxvf
alias -s bz2=tar -xjvf
alias -s java=$EDITOR
alias -s txt=$EDITOR
alias -s PKGBUILD=$EDITOR
alias -s c=$EDITOR

alias lsd='ls -ld *(-/DN)'
alias lsa='ls -ld .*'
alias f='find |grep'
alias dir='ls -1'

alias srr="sudo /etc/init.d/screen-cleanup start"
alias -g A="|awk"
alias -g B='|sed -r "s:\x1B\[[0-9;]*[mK]::g"'       # remove color, make things boring
alias -g C="|wc"
alias -g E="|sed"
alias -g G='|GREP_COLOR=$(echo 3$[$(date +%N)%6+1]'\'';1;7'\'') egrep -i --color=always'
alias -g H="|head -n $(($LINES-2))"
alias -g L="|less"
alias -g P="|column -t"
alias -g R="|tac"
alias -g S="|sort"
alias -g T="|tail -n $(($LINES-2))"
alias -g X="|xargs"
alias -g N="> /dev/null"
alias -g NF="./*(oc[1])"      # last modified(inode time) file or directory

# add chroot for 32bits and 64bits compile 
#alias sw32="sudo chroot /home/liu/work/32bits/compile /bin/bash -c \"su - liu\""
alias sw32="sudo mount --bind /home/liu/work/32bits/code /home/liu/work/32bits/compile/home/liu/code; sudo chroot /home/liu/work/32bits/compile /bin/bash -c \"su - liu\""
alias sw64="sudo mount --bind /home/liu/work/64bits/code /home/liu/work/64bits/compile/home/liu/code; sudo chroot /home/liu/work/64bits/compile /bin/bash -c \"su - liu\""

alias com="sudo minicom -R utf-8"

# tmux or screen ?
(bin-exist tmux) && alias s=tmux || alias s=screen

#file types
(bin-exist apvlv) && alias -s pdf=apvlv
alias -s ps=gv
for i in jpg png;           alias -s $i=sxiv
for i in avi rmvb wmv;      alias -s $i=mplayer
for i in rar zip 7z lzma;   alias -s $i="7z x"

#no correct for mkdir mv and cp
for i in mkdir mv cp;       alias $i="nocorrect $i"
alias find='noglob find'        # noglob for find
alias grep='grep -I --color=auto'
alias egrep='egrep -I --color=auto'
alias cal='cal -3'
alias freeze='kill -STOP'
alias ls=$'ls -h --color=auto -X --time-style="+\e[33m[\e[32m%Y-%m-%d \e[35m%k:%M\e[33m]\e[m"'
alias vi='vim'
alias ll='ls -l'
alias df='df -Th'
alias du='du -h'
#show directories size
alias dud='du -s *(/)'
#date for US and CN
alias adate='for i in US/Eastern Australia/{Brisbane,Sydney} Asia/{Hong_Kong,Singapore} Europe/Paris; do printf %-22s "$i:";TZ=$i date +"%m-%d %a %H:%M";done'
#bloomberg radio
alias bloomberg='mplayer mms://media2.bloomberg.com/wbbr_sirus.asf'
alias pyprof='python -m cProfile'
alias python='nice python'
alias info='info --vi-keys'
alias rsync='rsync --progress --partial'
alias ri='ri -T -f ansi --width=$COLUMNS'
alias history='history 1'       #zsh specific
alias zhcon='zhcon --utf8'
alias vless="/usr/share/vim/vim72/macros/less.sh"
del() {mv -vif -- $* ~/.Trash}
alias m='md5sum'
alias s='sha1sum'
alias port='netstat -ntlp'      #opening ports
#Terminal - Harder, Faster, Stronger SSH clients 
alias e264='mencoder -vf harddup -ovc x264 -x264encopts crf=22:subme=6:frameref=2:8x8dct:bframes=3:weight_b:threads=auto -oac copy'
#alias tree="tree --dirsfirst"
alias top10='print -l  ${(o)history%% *} | uniq -c | sort -nr | head -n 10'
alias gfw="autossh -M 10000 -f -q -N -D 7070 vortex@vpn.me -p2259"
alias gfw3="autossh -TfN -D 7070 action@apn.toio -p17"

alias soff='sleep 5 && xset dpms force off'

alias gbkssh="luit -encoding gbk ssh"
(bin-exist pal) && alias pal="pal -r 0-7 --color"
[ -d /usr/share/man/zh_CN ] && alias cman="MANPATH=/usr/share/man/zh_CN man"
alias tnethack='telnet nethack.alt.org'
alias tslashem='telnet slashem.crash-override.net'
#######adam
#alias ct='ctags -R --fields=+lS && cscope -Rbq'
alias gct='ctags -R --fields=+lS && gtags -i'
alias ct='ctags -R --fields=+lS'
alias df='df -h'
alias dt='dmesg | tail -n 20'
alias du='du -sh'
alias dx='xset s off && xset dpms 0 0 0'
alias ga='git add -A'
alias gc='git commit -a'
alias gd='git difftool'
alias gi='git add -i'
alias gl='git log --graph'
alias gp='git push'
alias grep='grep --color=auto'
alias gr='git ls-files -d |xargs git checkout --'
alias gs='git status'
alias gu='git pull'
alias gw='git show'
alias hb='sudo pm-hibernate'
alias ht='sudo halt -p'

alias la='ls -lA --color=auto'
alias lh='ls -lAh --color=auto'
alias ll='ls -l --color=auto'
alias smth='luit -encoding gbk -- telnet newsmth.org'
#alias ntp='sudo ntpdate pool.ntp.org && sudo hwclock --systohc'
alias off='sudo poff'
alias on='sudo pon dsl-provider'
alias rb='sudo reboot'
#alias sp='sudo pm-suspend'
alias x='startx'
#alias mv='mv -i'
#alias rm='rm -i'

# proxychains 相关 alias
alias gcalcli='proxychains -q gcalcli'

# mkdir, cd into it
mkcd () {
    mkdir -p "$*"
    cd "$*"
}
####adam

##}}}
#

TMUX_MOD=`[ -z "$TMUX" ] && echo 1`
TMUX_TERM_LIST=(Apple_Terminal iTerm.app rxvt-unicode-256color xterm-256color)

_check_term_app() {
    TP=''
    if [ -n "$TERM_PROGRAM" ];then
        TP=$TERM_PROGRAM
    elif [ -n "$TERM" ]; then
        TP=$TERM
    else
        echo 'Either $TERM or $TERM_PROGRAM is set, cannot determine terimnal name.'
        return 1
    fi

    res=${TMUX_TERM_LIST[@]/${TP}/yes}
    if [ -n "`echo $res | grep 'yes'`" ]; then
        return 0
    else
        return 1
    fi
}

DEFAULT_SESSION=new
CODE="
_timeout() {
    echo $DEFAULT_SESSION
    exit
}

_main() {
    SELECT_CMD
}
"

_start_tmux(){
    # If timeout script doesn't exist then skip starting tmux
    if [ ! -x /usr/bin/timeout ]; then
        echo Warning: /usr/bin/timeout doesn\'t exist
        return
    fi

    # Start tmux if no tmux is running under current shell
    if [ "`_check_term_app && echo 1`" = "1" -a "z$TMUX_MOD" = "z1" ];then
        session_list=`tmux list-sessions | sed "s/.*/'&'/g" | tr '\n' ' '`
        if [ -n "$session_list" ];then
            echo "Select an session, default is $DEFAULT_SESSION , enter q to cancel starting tmux"
            SELECT_CMD="
            select session in ${session_list[*]}; do
                target=\`echo \$session | awk '{print \$1}'\`
                if [ -n \"\$session\" ];then
                    echo \$target
                else
                    echo \$REPLY
                fi
                break
            done
            "

            CODE=${CODE/SELECT_CMD/$SELECT_CMD}
            ~/bin/timeout 3 "$CODE" > /tmp/.zsh_start_$$
            target=`cat /tmp/.zsh_start_$$`
            rm -f /tmp/.zsh_start_$$
        fi

        if [ "$target" = 'q' -o "$target" = "Q" ];then
            return 0
        fi
        ## Open tmux
        cmd='tmux -2'
        if [ -n "$target" -a "$target" != "new" ];then
            cmd="$cmd attach -t $target"
        fi

        if [ -z "`which tmux`" ];then
            echo Tmux is not found. Try to install it first...
            echo Try installing using 'sudo apt-get install tmux...'
            sudo apt-get install tmux
        fi

        eval "$cmd" || echo "Tmux exited abnormally. Exit code $?"
        exit 0
    fi
}

#_start_tmux

sss () { ssh -l root $1; }

[ $(uname -s | grep -c CYGWIN) -eq 1 ] && OS_NAME="CYGWIN" || OS_NAME=`uname -s`
function pclip() {
    if [ $OS_NAME == CYGWIN ]; then
        putclip $@;
    elif [ $OS_NAME == Darwin ]; then
        pbcopy $@;
    else
        if [ -x /usr/bin/xsel ]; then
            xsel -ib $@;
        else
            if [ -x /usr/bin/xclip ]; then
                xclip -selection c $@;
            else
                echo "Neither xsel or xclip is installed!"
            fi
        fi
    fi
}

function ff()
{
    local fullpath=$*
    local filename=${fullpath##*/} # remove "/" from the beginning
    filename=${filename##*./} # remove  ".../" from the beginning
    echo file=$filename
    #  only the filename without path is needed
    # filename should be reasonable
    local cli=`find $PWD -not -iwholename '*/target/*' -not -iwholename '*.svn*' -not -iwholename '*.git*' -not -iwholename '*.sass-cache*' -not -iwholename '*.hg*' -type f -iwholename '*'${filename}'*' -print | percol`
    echo ${cli}
    echo -n ${cli} |pclip;
}

function ppgrep() {
    if [[ $1 == "" ]]; then
        PERCOL=percol
    else
        PERCOL="percol --query $1"
    fi
    ps aux | eval $PERCOL | awk '{ print $2 }'
}

function ppkill() {
    if [[ $1 =~ "^-" ]]; then
        QUERY=""            # options only
    else
        QUERY=$1            # with a query
        [[ $# > 0 ]] && shift
    fi
    ppgrep $QUERY | xargs kill $*
}

function exists { which $1 &> /dev/null }

if exists percol; then
    function percol_select_history() {
        local tac
        exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
        BUFFER=$(fc -l -n 1 | eval $tac | percol --query "$LBUFFER")
        CURSOR=$#BUFFER         # move cursor
        zle -R -c               # refresh
    }

    zle -N percol_select_history
    bindkey '^R' percol_select_history
fi

function pattach() {
    if [[ $1 == "" ]]; then
        PERCOL=percol
    else
        PERCOL="percol --query $1"
    fi

    sessions=$(tmux ls)
    [ $? -ne 0 ] && return

    session=$(echo $sessions | eval $PERCOL | cut -d : -f 1)
    if [[ -n "$session" ]]; then
        tmux att -t $session
    fi
}

eval "$(fasd --init auto)"

typeset -U PATH

