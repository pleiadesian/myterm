#!/bin/bash

echo "Home: $(echo ~)"
if [ $(echo ~) = "/root" ];then
  echo "Do not install in root!"
  exit
fi
cp -v ~/.zshrc ~/.zshrc_backup
sudo rm -r ~/.tmux.conf ~/.viminfo ~/.oh-my-zsh ~/.zshrc ~/.cache/*im*
echo "Installing zsh..."
rm -r ~/.oh-my-zsh
git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
chsh -s /bin/zsh
zsh ./myvim.sh
echo "Installing shell integration..."
curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash
cp .dircolors ~/.dircolors
echo "
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval \"\$(dircolors -b ~/.dircolors)\" || eval \"\$(dircolors -b)\"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

source ~/.pathrc  # configure your PATH
source ~/.proxyrc  # configure your proxy

" >> ~/.zshrc
sed -i.bak 's/prompt_segment blue $CURRENT_FG/prompt_segment cyan $CURRENT_FG/g' ~/.oh-my-zsh/themes/agnoster.zsh-theme && rm ~/.oh-my-zsh/themes/agnoster.zsh-theme.bak
