export ZSH="$HOME/.oh-my-zsh"

# personal configs
ZSH_THEME="ned"
plugins=(git rails bundler)

# zsh conf
source $ZSH/oh-my-zsh.sh
export EDITOR='nvim'

# rbenv setup
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# nodenv setup
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

# aliases
alias lzd='lazydocker'
alias spt='spotify_player'
alias notes='cd ~/Documents/notes && nvim'
alias buk='cd ~/Documents/Buk/buk-webapp && tmux'

# other paths
export PATH="$PATH:/opt/nvim/"
export PATH="$PATH:/home/$USER/.cargo/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH=$PATH:/usr/bin
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
