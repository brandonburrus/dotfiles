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

export EDITOR="nvim"
export GOPATH=$HOME/go
export M2_PATH=$HOME/.m2
export MYVIMRC=$HOME/.config/nvim/init.vim
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

clear
