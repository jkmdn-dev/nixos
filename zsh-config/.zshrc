# Enable Powerlevel10k instant prompt. Should stay close to the top of /var/config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# ------------------------------------------------------------------------------
# zsh-autocomplete setup
# ------------------------------------------------------------------------------

if [[ ! -d "${ZDOTDIR}/zsh-autocomplete" ]]; then
  git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git "${ZDOTDIR}/zsh-autocomplete" 
fi

source "${ZDOTDIR}/zsh-autocomplete/zsh-autocomplete.plugin.zsh"


# ------------------------------------------------------------------------------
# color setup
# ------------------------------------------------------------------------------

# if [ -f ~/.dir_colors ]; then
#   eval $(dircolors $HOME/.dir_colors)
# fi


# ------------------------------------------------------------------------------
# powerlevel10k setup
# ------------------------------------------------------------------------------

if [[ ! -d "${ZDOTDIR}/powerlevel10k" ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZDOTDIR}/powerlevel10k"
fi

source "${ZDOTDIR}/.p10k.zsh"

source "${ZDOTDIR}/powerlevel10k/powerlevel10k.zsh-theme"

# ------------------------------------------------------------------------------
# zoxide setup 
# ------------------------------------------------------------------------------

# source "${ZDOTDIR}/zoxide.zsh"
# eval "$(zoxide init zsh)"


# ------------------------------------------------------------------------------
# mise setup 
# ------------------------------------------------------------------------------

# eval "$(~/.local/bin/mise activate zsh)"
# mise use -g node@latest &>/dev/null
# mise use -g python@latest &>/dev/null
# mise use -g bun@latest &>/dev/null

export CLICOLOR=1
