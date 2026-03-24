plugins=(git z zsh-autosuggestions zsh-vi-mode)

export ZSHRC=$HOME/.zshrc
export ZSH=$HOME/.oh-my-zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#bbbbbb,bg=bold"
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/highlighters
export ZSH_THEME="agnoster"

source $ZSH/oh-my-zsh.sh
function zvm_after_init() {
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
}

export ALIASES=$HOME/aliases.sh
export BUN_INSTALL="$HOME/.bun"
export EDITOR="nvim"
export GOPATH=$HOME/go
export M2_PATH=$HOME/.m2
export NVM_DIR="$HOME/.nvm"
export DVM_DIR="$HOME/.dvm"
export VIMRC=$HOME/.config/nvim/init.lua
export VISUAL="nvim"
export OPENCODE=$HOME/.config/opencode

export PATH=$PATH:$HOME/.cargo/bin/
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$BUN_INSTALL/bin
export PATH=$PATH:$HOME/.scripts
export PATH=$PATH:/usr/local/share/npm/bin:/usr/local/bin:/usr/local/sbin
export PATH=$PATH:$DVM_DIR/bin
export PATH=$PATH:$HOME/.pub-cache/bin
export PATH=$PATH:$HOME/.local/bin

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH" 
eval "$(pyenv init - zsh)"

[ -f ~/aliases.sh ] && source ~/aliases.sh;
[ -f ~/.bash_profile ] && source ~/.bash_profile;
[ -f ~/.zshrc.local ] && source ~/.zshrc.local;
[ -f $OPENCODE/opencode.env ] && source $OPENCODE/opencode.env;

[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" 
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
