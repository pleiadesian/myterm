#!/bin/bash


cleanup() {
  echo "================================"
  echo "Cleaning old configs..."
  cp -v ~/.zshrc ~/.zshrc.backup
  cp -v ~/.tmux.conf ~/.tmux.conf.backup
  rm -r ~/.tmux.conf ~/.viminfo ~/.oh-my-zsh ~/.zshrc ~/.cache/*im*
  touch ~/.pathrc ~/.proxyrc # TODO: add desc for this
}

install_zsh() {
  echo "================================"
  echo "Installing oh-my-zsh..."
  # Basic zsh installation
  git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh # TODO: require git
  cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
  chsh -s /bin/zsh # TODO: require zsh
  # zsh custom setups
  # zsh plugins
  sed -i.bak 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"ys\"/g' ~/.zshrc &&
    rm ~/.zshrc.bak
  sed -i.bak 's/plugins=(git)/plugins=(git zsh-syntax-highlighting ' \
    'zsh-autosuggestions sudo autojump extract)/g' \
    ~/.zshrc && rm ~/.zshrc.bak # TODO: require autojump
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
  # dircolor
  cp config/dircolors ~/.dircolors
  echo "
  # enable color support of ls and also add handy aliases
  if [ -x /usr/bin/dircolors ]; then
      test -r ~/.dircolors && eval \"\$(dircolors -b ~/.dircolors)\" || \
        eval \"\$(dircolors -b)\"
      alias ls='ls --color=auto'
      alias grep='grep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias egrep='egrep --color=auto'
  fi

  source ~/.pathrc  # configure your PATH
  source ~/.proxyrc  # configure your proxy

  " >>"${HOME}"/.zshrc

  source "$HOME"/.zshrc # apply new zsh config
}

install_tmux() {
  echo "================================"
  echo "Installing oh-my-tmux..." # TODO: require tmux
  git clone https://github.com/gpakosz/.tmux.git "$HOME"/.tmux
  ln -s -f "${HOME}"/.tmux/.tmux.conf "${HOME}"/.tmux.conf
  cp "${HOME}"/.tmux/.tmux.conf.local "${HOME}"/.tmux.conf.local # Add desc
  tmux source-file ~/.tmux.conf                                  # apply new tmux config
}

install_vim() {
  # TODO: complete this
  # TODO: require vim
  echo ""
}

install_anaconda() {
  echo "================================"
  echo "Installing Anaconda..."
  if [[ $(uname) == "Darwin" ]]; then
    bash <(curl -s "https://repo.anaconda.com/archive/" \
      "Anaconda3-2021.05-MacOSX-x86_64.sh")
  elif [[ $(uname) == "Linux" ]]; then
    bash <(curl -s "https://repo.anaconda.com/archive/" \
      "Anaconda3-2021.05-Linux-x86_64.sh")
  else
    echo "$(uname) OS type is not supported yet"
    exit 1
  fi
}

install_util() {
  echo "================================"
  echo "Install utilities..."
  curl "https://gist.githubusercontent.com/pleiadesian/" \
    "7873552558e350d9405f989087266028/raw/" \
    "b7cc26d59e6a101e2095880ecedf379dd8983120/jobnotifier.py" \
    >~/anaconda3/bin/jobnotifier
  sudo chmod +x ~/anaconda3/bin/jobnotifier
}

main() {
  # Check installation location
  echo "Home: $HOME"
  if [ "$HOME" = "/root" ]; then
    echo "Do not install in root!"
    exit
  fi

  # Check OS type
  if [[ ! ($(uname) == "Darwin" || $(uname) == "Linux") ]]; then
    echo "$(uname) OS type is not supported yet"
    exit 1
  fi

  cleanup
  install_zsh
  install_tmux
  install_vim
  install_anaconda
  install_util
}
