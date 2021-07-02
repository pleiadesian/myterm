#!/bin/bash

echo "Home: $(echo ~)"
if [ $(echo ~) = "/root" ];then
  echo "Do not install in root!"
  exit
fi

echo "Cleaning old configs..."
cp -v ~/.zshrc ~/.zshrc_backup
touch ~/.pathrc ~/.proxyrc
sudo rm -r ~/.tmux.conf ~/.viminfo ~/.oh-my-zsh ~/.zshrc ~/.cache/*im*

echo "Installing zsh..."
touch ~/.pathrc
touch ~/.proxyrc
rm -r ~/.oh-my-zsh
git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
chsh -s /bin/zsh

sed -i.bak 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"agnoster\"/g' ~/.zshrc && rm ~/.zshrc.bak
sed -i.bak 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions sudo autojump extract)/g' ~/.zshrc && rm ~/.zshrc.bak
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
source ~/.zshrc

echo "Installing tmux..."
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
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
run '~/.tmux/plugins/tpm/tpm'
#### COLOUR (base16-solarized)

# This theme is a 256 color variant and it uses the color codes of the
# base16-solarized (256 color) terminal/shell theme:
# https://github.com/chriskempson/base16
# https://github.com/chriskempson/base16-shell

# It is based on the original tmux-colors-solarized light theme with some color
# codes changed (to map solarized base2, base00, orange, base1).

# In fact, this theme may be used in combination with any base16 256 color
# terminal/shell theme. But it will probably look a bit 'burnt' (i.e.
# solarized).  It better matches the base16-solarized-light and
# base16-solarized-dark terminal/shell color themes.

# default statusbar colors
set-option -g status-style fg=colour17,bg=colour28 #yellow and base2

# default window title colors
set-window-option -g window-status-style fg=colour17,bg=default #base00 and default
#set-window-option -g window-status-style dim

# active window title colors
set-window-option -g window-status-current-style fg=colour17,bg=default #orange and default
#set-window-option -g window-status-current-style bright

# pane border
set-option -g pane-border-style fg=colour28 #base2
set-option -g pane-active-border-style fg=colour22 #base1

# message text
set-option -g message-style fg=colour16,bg=colour18 #orange and base2

# pane number display
set-option -g display-panes-active-colour blue #blue
set-option -g display-panes-colour colour16 #orange

# clock
set-window-option -g clock-mode-colour green #green

# bell
set-window-option -g window-status-bell-style fg=colour18,bg=red #base2, red)
# Linux only
set -g mouse on
bind -n WheelUpPane if-shell -F -t = \"#{mouse_any_flag}\" \"send-keys -M\" \"if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'\"
bind -n WheelDownPane select-pane -t= \; send-keys -M
bind -n C-WheelUpPane select-pane -t= \; copy-mode -e \; send-keys -M
bind -T copy-mode-vi    C-WheelUpPane   send-keys -X halfpage-up
bind -T copy-mode-vi    C-WheelDownPane send-keys -X halfpage-down
bind -T copy-mode-emacs C-WheelUpPane   send-keys -X halfpage-up
bind -T copy-mode-emacs C-WheelDownPane send-keys -X halfpage-down

# To copy, left click and drag to highlight text in yellow,
# once you release left click yellow text will disappear and will automatically be available in clibboard
# # Use vim keybindings in copy mode
setw -g mode-keys vi
# Update default binding of `Enter` to also use copy-pipe
unbind -T copy-mode-vi Enter
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel \"xclip -selection c\"
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel \"xclip -in -selection clipboard\"
" >> ~/.tmux.conf
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

# Install Anaconda
echo "Installing Anaconda..."
if [[ $(uname) == "Darwin" ]]; then
  bash <(curl -s https://repo.anaconda.com/archive/Anaconda3-2021.05-MacOSX-x86_64.sh)
else
  bash <(curl -s https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh)
fi

# Install my scripts
echo "Install utilities..."
curl https://gist.githubusercontent.com/pleiadesian/7873552558e350d9405f989087266028/raw/b7cc26d59e6a101e2095880ecedf379dd8983120/jobnotifier.py > ~/anaconda3/bin/jobnotifier
sudo chmod +x ~/anaconda3/bin/jobnotifier


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
