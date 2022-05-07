#!/bin/bash

if [ ! -d $HOME/.dotfiles ]; then
  git init --bare $HOME/.dotfiles
  dotfiles config --local status.showUntrackedFiles no
fi
