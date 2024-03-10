# ------------------------------------------------------------------------------
# environment variables
# ------------------------------------------------------------------------------

# editor
export EDITOR="nvim"
export VISUAL="nvim"

# zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000

source $ZDOTDIR/my-utilities.zsh

# ------------------------------------------------------------------------------
# aliases
# ------------------------------------------------------------------------------

alias tmux=_tmux_cmd
alias rtmux=/usr/bin/tmux

# alias nvim=_nvim_cmd
# alias rnvim=_nvim_cmd
# alias zshconf="nvim $ZDOTDIR/.zshrc"
# alias zshenv="nvim $ZDOTDIR/.zshenv"
# alias tmuxconf="nvim $XDG_CONFIG_HOME/tmux/tmux.conf"
# alias nvimconf="nvim $XDG_CONFIG_HOME/nvim/init.lua"

# ------------------------------------------------------------------------------
# key bindings
# ------------------------------------------------------------------------------

bindkey -e
