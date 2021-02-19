eval $(ssh-agent)
ssh-add -A 2> /dev/null
export DOTFILES="$HOME/.dotfiles"
export XDG_CONFIG_HOME="$HOME/.config"
alias check='ssh-add -l'
alias devbox='ssh devbox-ezeugo'
alias exp='cd ~/src/experimental'
alias vimrc='vim ~/.vimrc'
alias zshrc='vim ~/.zshrc'
cd ~/src/coda/
source ./setup-env.sh
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info --preview 'bat --style=numbers --color=always --line-range :500 {}'"
# Run tmux if exists
# if command -v tmux>/dev/null; then
#   # attempt to reconnect to existing session or create new
#   if test -z "$TMUX"; then
#     session_name=$(
#     tmux list-sessions      |
#       grep -v attached      |
#       grep -oE '^(\w|\s)+:' |
#       head -1
#     )
#     # default grep has no regex lookahead; prune colon from "$session_name"
#     if test $session_name; then exec tmux attach -t ${session_name: : -1}; else exec tmux; fi
#   fi
# else
#   echo "tmux not installed. Run ${DOTFILES/#$HOME/~}/deploy.sh to configure dependencies..."
# fi

# implicit update of submodules in subshell if on master branch
(
  cd "$DOTFILES"
  if [[ $(git symbolic-ref HEAD | sed -e 's/^refs\/heads\///') == 'master' ]]; then
    git pull -q
    git submodule update --init --recursive -q
  fi
)

source "$DOTFILES/zsh/zshrc.sh"
source "$DOTFILES/zsh/ext.sh"
