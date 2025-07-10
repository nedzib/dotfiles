export ZSH="$HOME/.oh-my-zsh"
# source $HOME/.zshrc_env
# personal configs
ZSH_THEME="robbyrussell"
plugins=(git rails bundler aliases colorize tmux)

# zsh conf
source $ZSH/oh-my-zsh.sh
export EDITOR='nvim'

# rbenv setup
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# aliases
alias lzd='lazydocker'
alias spt='spotify_player'
alias buk='tmuxifier load-session buk-webapp'
alias lines='tmuxifier load-session lines'
alias rbcm='bin/rubocop -A $(git ls-files --modified | grep ".rb$")'
alias srbt='clear; echo -e && bin/spoom srb tc'
alias cls='clear; echo -e'
alias ls='exa --icons --color=always --group-directories-first'
# other paths
export PATH="$HOME/.tmuxifier/bin:$PATH"
export PATH="$PATH:/opt/nvim/"
export PATH="$PATH:/home/$USER/.cargo/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH=$PATH:/usr/bin
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


# nodenv setup
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

        # okteto setup
        export PATH="/usr/local/bin:$PATH"
