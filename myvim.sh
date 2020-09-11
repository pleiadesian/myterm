#!/bin/zsh
sed -i.bak 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"agnoster\"/g' ~/.zshrc && rm ~/.zshrc.bak
sed -i.bak 's/plugins=(git)/plugins=(git zsh-autosuggestions sudo)/g' ~/.zshrc && rm ~/.zshrc.bak
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
source ~/.zshrc
echo "Installing zsh in tmux..."
echo "set -g default-shell /bin/zsh\nset -g default-command /bin/zsh\n" > ~/.tmux.conf
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
