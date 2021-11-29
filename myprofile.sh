#!/bin/bash

GITURL=git@github.com:
# GITURL=${GITURL}

cleanup() {
  echo "================================"
  echo "Cleaning old configs..."
  cp -v "${HOME}"/.zshrc "${HOME}"/.zshrc.backup
  cp -v "${HOME}"/.tmux.conf "${HOME}"/.tmux.conf.backup
  sudo rm -r "${HOME}"/.tmux "${HOME}"/.tmux.conf "${HOME}"/.viminfo "${HOME}"/.oh-my-zsh "${HOME}"/.zshrc "${HOME}"/.cache/*im*
  touch "${HOME}"/.pathrc "${HOME}"/.proxyrc # TODO: add desc for this
}

install_zsh() {
  echo "================================"
  echo "Installing oh-my-zsh..."
  # Basic zsh installation
  git clone --depth=1 ${GITURL}robbyrussell/oh-my-zsh "${HOME}"/.oh-my-zsh # TODO: require git
  cp "${HOME}"/.oh-my-zsh/templates/zshrc.zsh-template "${HOME}"/.zshrc
  chsh -s /bin/zsh # TODO: require zsh
  # zsh custom setups
  # zsh plugins
  sed -i.bak 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"ys\"/g' "${HOME}"/.zshrc &&
    rm "${HOME}"/.zshrc.bak
  sed -i.bak 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions sudo autojump extract)/g' \
    "${HOME}"/.zshrc && rm "${HOME}"/.zshrc.bak # TODO: require autojump
  git clone ${GITURL}zsh-users/zsh-syntax-highlighting \
    "${ZSH_CUSTOM:-"${HOME}"/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
  git clone ${GITURL}zsh-users/zsh-autosuggestions \
    "${ZSH_CUSTOM:-"${HOME}"/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
  # dircolor
  cp config/dircolors "${HOME}"/.dircolors
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

  # export for tmux
  export EDITOR=vim

  # alias for copy
  alias copy="tmux save-buffer - | xclip -i -selection clipboard > /dev/null 2>&1"

  # set keyboard rate
  xset r rate 250 45

  # set language
  export LC_ALL=C

  bindkey -v
  bindkey \"^P\" up-line-or-search
  bindkey \"^N\" down-line-or-search

  source ~/.customrc  # configure your customized zshrc config

  " >>"${HOME}"/.zshrc

# FIXME: unnecessary source
#  source "${HOME}"/.zshrc
}

install_tmux() {
  echo "================================"
  echo "Installing oh-my-tmux..." # TODO: require tmux
  git clone ${GITURL}gpakosz/.tmux.git "$HOME"/.tmux
  ln -s -f "${HOME}"/.tmux/.tmux.conf "${HOME}"/.tmux.conf
  cp "${HOME}"/.tmux/.tmux.conf.local "${HOME}"/.tmux.conf.local # Add desc
  tmux source-file "${HOME}"/.tmux.conf                                  # apply new tmux config
}

install_vim() {
  # TODO: complete this
  # TODO: require vim
  echo "================================"
  echo "Installing SpaceVim..." # TODO: require tmux
  curl -sLf https://spacevim.org/install.sh | bash
  vim
  echo "[[layers]]
    name = \"lang#c\"
  [[layers]]
    name = \"lang#python\"
  [[layers]]
    name = \"lsp\"
    filetypes = [
      \"c\",
      \"cpp\"
    ]
    [layers.override_cmd]
      c = [\"clangd\"]
  [[layers]]
    name = \"format\"
  [[layers]]
     name = \"debug\"
  " >> ~/.SpaceVim.d/init.toml
}

install_anaconda() {
  echo "================================"
  echo "Installing Anaconda..."
  if [[ $(uname) == "Darwin" ]]; then
    bash <(curl -s "https://repo.anaconda.com/archive/Anaconda3-2021.05-MacOSX-x86_64.sh")
  elif [[ $(uname) == "Linux" ]]; then
    bash <(curl -s "https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh")
  else
    echo "$(uname) OS type is not supported yet"
    exit 1
  fi
}

install_util() {
  # FIXME
  echo ""
#  echo "================================"
#  echo "Install utilities..."
#  curl "https://gist.githubusercontent.com/pleiadesian/7873552558e350d9405f989087266028/raw/b7cc26d59e6a101e2095880ecedf379dd8983120/jobnotifier.py" \
#    >"${HOME}"/anaconda3/bin/jobnotifier
#  sudo chmod +x "${HOME}"/anaconda3/bin/jobnotifier
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

main
