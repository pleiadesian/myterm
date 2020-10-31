#!/bin/zsh
sed -i.bak 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"agnoster\"/g' ~/.zshrc && rm ~/.zshrc.bak
sed -i.bak 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions sudo autojump extract)/g' ~/.zshrc && rm ~/.zshrc.bak
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
source ~/.zshrc
echo "Installing zsh in tmux..."
echo "set -g default-shell /bin/zsh" >> ~/.tmux.conf
echo "set -g default-command /bin/zsh" >> ~/.tmux.conf
echo "set -g default-terminal \"screen-256color\"" >> ~/.tmux.conf
echo "set-window-option -g visual-bell on" >> ~/.tmux.conf
echo "set-window-option -g bell-action other" >> ~/.tmux.conf
echo "unbind C-b" >> ~/.tmux.conf
echo "set -g prefix `" >> ~/.tmux.conf
echo "bind-key ` send-prefix" >> ~/.tmux.conf
bash tmux source-file ~/.tmux.conf
echo "Installing SpaceVim..."
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
