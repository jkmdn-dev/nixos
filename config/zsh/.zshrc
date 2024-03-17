# If not in tmux, start tmux.

if [ -z $TMUX ]; then
  tmux attach -t main || tmux new -s main
fi

function zcompile-many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

# Clone and compile to wordcode missing plugins.
if [[ ! -e ${ZDOTDIR}/zsh-syntax-highlighting ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZDOTDIR}/zsh-syntax-highlighting
  zcompile-many ${ZDOTDIR}/zsh-syntax-highlighting/{zsh-syntax-highlighting.zsh,highlighters/*/*.zsh}
fi
if [[ ! -e ${ZDOTDIR}/zsh-autosuggestions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ${ZDOTDIR}/zsh-autosuggestions
  zcompile-many ${ZDOTDIR}/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh}
fi
if [[ ! -e ${ZDOTDIR}/powerlevel10k ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZDOTDIR}/powerlevel10k
  make -C ${ZDOTDIR}/powerlevel10k pkg
fi

if [[ ! -e ${ZDOTDIR}/fzf-tab ]]; then
  git clone --depth=1 https://github.com/Aloxaf/fzf-tab ${ZDOTDIR}/fzf-tab
  zcompile-many ${ZDOTDIR}/fzf-tab/{fzf-tab.zsh,lib/**/*.zsh}
fi

# Activate Powerlevel10k Instant Prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable the "new" completion system (compsys).
autoload -Uz compinit && compinit
[[ ${ZDOTDIR}/.zcompdump.zwc -nt ${ZDOTDIR}/.zcompdump ]] || zcompile-many ${ZDOTDIR}/.zcompdump
unfunction zcompile-many

# ---------------------------------------------------------------------------------
# Load plugins
# ---------------------------------------------------------------------------------

# these are from zsh-bench github repo for diy++ 
#
# do these first since the plugins since p10k might override lots of stuff
#   it's not apparent exactly what p10k force upon the configurations
#
# it would be nice to use zsh4humans (same author as p10k) but...
#   z4h takes over the control of everything, including tmux
#   and it is really annoying, it is very obfuscated, so it is very hard
#   to fix stuff by your self. it also installs a bunch of binaries.
#   Nothing z4h does works well in NixOS. In the end, it is to oppionated,
#   probably only works well for the author.
#
source ${ZDOTDIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ${ZDOTDIR}/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${ZDOTDIR}/powerlevel10k/powerlevel10k.zsh-theme
source ${ZDOTDIR}/.p10k.zsh

source ${ZDOTDIR}/fzf-tab/fzf-tab.zsh
source ${ZDOTDIR}/lscolors.zsh

# ---------------------------------------------------------------------------------
# fzf-tab configurations
# ---------------------------------------------------------------------------------


export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"


# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# tmux popup
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# ---------------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------------

eza_params=('--git' '--icons' '--classify' '--group-directories-first' '--time-style=long-iso' '--group' '--color-scale-mode=fixed')

alias ls='eza $eza_params'
alias l='eza --git-ignore $eza_params'
alias ll='eza --all --header --long $eza_params'
alias llm='eza --all --header --long --sort=modified $eza_params'
alias la='eza -lbhHigUmuSa'
alias lx='eza -lbhHigUmuSa@'
alias lt='eza --tree $eza_params'
alias tree='eza --tree $eza_params'
