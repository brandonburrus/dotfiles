# Brandon Burrus .zshrc
clear

plugins=(\
  ag \
  autopep8 \
  aws \
  bazel \
  brew \
  common-aliases \
  copybuffer \
  copyfile \
  docker \
  docker-compose \
  doctl \
  dotenv \
  fzf \
  gcloud \
  gh \
  git \
  gitignore \
  golang \
  gpg-agent \
  helm \
  history \
  jsontools \
  kubectl \
  minikube \
  node \
  npm \
  nvm \
  otp \
  pip \
  pipenv \
  postgres \
  python \
  redis-cli \
  ssh-agent \
  sudo \
  terraform \
  tmux \
  yarn \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zsh-vi-mode \
)

export EDITOR="vim"
export GOPATH=$HOME/go
export M2_PATH=$HOME/.m2
export MYVIMRC=$HOME/.vimrc
export MYZSHRC=$HOME/.zshrc
export ZSH=$HOME/.oh-my-zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#bbbbbb,bg=bold"
export ZSH_THEME="agnoster"

source $ZSH/oh-my-zsh.sh

export PATH=$PATH:$HOME/.scripts
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/Users/brandon/Library/Python/3.10/bin
export PATH=$PATH:/usr/local/share/npm/bin:/usr/local/bin:/usr/local/sbin

[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.bash_profile ] && source ~/.bash_profile;

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

clear

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
