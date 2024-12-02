plugins=(git ag zsh-autosuggestions zsh-syntax-highlighting zsh-vi-mode)

export ALIASES=$HOME/.aliases
export EDITOR="hx"
export VISUAL="hx"
export GOPATH=$HOME/go
export M2_PATH=$HOME/.m2
export VIMRC=$HOME/.config/nvim/init.lua

export ZSHRC=$HOME/.zshrc
export ZSH=$HOME/.oh-my-zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#bbbbbb,bg=bold"
export ZSH_THEME="agnoster"

source $ZSH/oh-my-zsh.sh

export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.scripts
export PATH=$PATH:/usr/local/share/npm/bin:/usr/local/bin:/usr/local/sbin

[ -f ~/.aliases ] && source ~/.aliases;
[ -f ~/.bash_profile ] && source ~/.bash_profile;
[ -f ~/.zshrc.local ] && source ~/.zshrc.local;


export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completi

[[ -s "/Users/brandon/.gvm/scripts/gvm" ]] && source "/Users/brandon/.gvm/scripts/gvm"

clear
