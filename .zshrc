plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-vi-mode)

export ZSHRC=$HOME/.zshrc
export ZSH=$HOME/.oh-my-zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#bbbbbb,bg=bold"
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/highlighters
export ZSH_THEME="agnoster"

source $ZSH/oh-my-zsh.sh

export ALIASES=$HOME/.aliases
export BUN_INSTALL="$HOME/.bun"
export EDITOR="nvim"
export GOPATH=$HOME/go
export M2_PATH=$HOME/.m2
export NVM_DIR="$HOME/.nvm"
export VIMRC=$HOME/.config/nvim/init.lua
export VISUAL="nvim"

export PATH=$PATH:$HOME/.cargo/bin/
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$BUN_INSTALL/bin
export PATH=$PATH:$HOME/.scripts
export PATH=$PATH:/usr/local/share/npm/bin:/usr/local/bin:/usr/local/sbin

[ -f ~/.aliases ] && source ~/.aliases;
[ -f ~/.bash_profile ] && source ~/.bash_profile;
[ -f ~/.zshrc.local ] && source ~/.zshrc.local;


[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" 
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
[ -s "/Users/brandon/.bun/_bun" ] && source "/Users/brandon/.bun/_bun"

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
