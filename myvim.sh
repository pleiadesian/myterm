#!/bin/zsh
sed -i.bak 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"agnoster\"/g' ~/.zshrc && rm ~/.zshrc.bak
sed -i.bak 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions sudo autojump extract)/g' ~/.zshrc && rm ~/.zshrc.bak
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
source ~/.zshrc
echo "Installing zsh in tmux..."
echo "set -g default-shell /bin/zsh
set -g default-command /bin/zsh
set -g default-terminal \"screen-256color\"
set-window-option -g visual-bell on
set-window-option -g bell-action other
unbind C-b
set -g prefix \`
bind-key \` send-prefix
set -g mouse on
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'fcsonline/tmux-thumbs'

# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'git@github.com:user/plugin'
# set -g @plugin 'git@bitbucket.com:user/plugin'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'" >> ~/.tmux.conf
cat tmuxcolors.conf >> ~/.tmux.conf 
tmux source-file ~/.tmux.conf
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
