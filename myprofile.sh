#!/bin/bash

echo "Home: $(echo ~)"
if [ $(echo ~) = "/root" ];then
  echo "Do not install in root!"
  exit
fi
sudo rm -r ~/.tmux.conf ~/.viminfo ~/.oh-my-zsh ~/.zshrc ~/.cache/*im*
echo "Installing zsh..."
rm -r ~/.oh-my-zsh
git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
chsh -s /bin/zsh
zsh ./myvim.sh
echo "Installing shell integration..."
curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash
