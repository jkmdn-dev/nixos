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

# make tab cycle through suggestions
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# make enter accept the current suggestion
bindkey -M menuselect '\r' .accept-line

# ------------------------------------------------------------------------------
# zsh-syntax-highlighting setup
# ------------------------------------------------------------------------------

if [[ ! -d "${ZDOTDIR}/fast-syntax-highlighting" ]]; then
  git clone --depth 1 -- https://github.com/zdharma-continuum/fast-syntax-highlighting "${ZDOTDIR}/fast-syntax-highlighting"
fi

source "${ZDOTDIR}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
fast-theme base16 &> /dev/null

# ------------------------------------------------------------------------------
# powerlevel10k setup
# ------------------------------------------------------------------------------

if [[ ! -d "${ZDOTDIR}/powerlevel10k" ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZDOTDIR}/powerlevel10k"
fi

source "${ZDOTDIR}/.p10k.zsh"

source "${ZDOTDIR}/powerlevel10k/powerlevel10k.zsh-theme"

export CLICOLOR=1
