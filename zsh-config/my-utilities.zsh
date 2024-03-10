# ---------
# tmux
# ---------

function _tmux_cmd {
  if tmux has-session -t main 2>/dev/null; then
    tmux attach-session -t main
  else
    tmux new-session -s main
  fi
}

# ---------
# nvim
# ---------

function _nvim_cmd {
  if [[ -f "$1" ]]; then
    ( cd $(dirname $1) && nvim "$@" )
  else
    nvim $@
  fi
}

# ------------------------------------------------------------------------------
# zsh
# ------------------------------------------------------------------------------

exec-zsh() {
  zle -I
  exec zsh <$TTY
}
