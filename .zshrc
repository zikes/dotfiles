# Shared across machines via the dotfiles repo.
#
# Machine-specific settings live outside the repo in ~/.zsh.local/, and every
# file there is optional:
#   path.zsh    extra PATH entries (login and interactive shells)
#   pre.zsh     runs before oh-my-zsh: feature flags, extra plugins
#   post.zsh    runs last: private aliases, overrides
#   functions/  autoloaded like ~/.zsh/functions, one directory per feature

# --- platform ------------------------------------------------------------
case $OSTYPE in
  linux*)  ZSH_OS=linux ;;
  darwin*) ZSH_OS=macos ;;
  *)       ZSH_OS=other ;;
esac
ZSH_LOCAL=$HOME/.zsh.local

source $HOME/.zsh/path.zsh

# --- feature flags and defaults -------------------------------------------
# Change any of these in ~/.zsh.local/pre.zsh, e.g.
#   ZSH_FEATURES[tmux-autostart]=no
#   plugins+=(docker)
typeset -gA ZSH_FEATURES=(
  tmux-autostart yes   # open tmux in every new terminal
  nvm            yes   # load nvm from ~/.nvm when it is installed
)
zfeature() { [[ ${ZSH_FEATURES[$1]} == (yes|on|true|1) ]] }

plugins=(git direnv)   # oh-my-zsh; any that aren't installed are skipped
ZSH_P10K=$HOME/powerlevel10k/powerlevel10k.zsh-theme

[[ -r $ZSH_LOCAL/pre.zsh ]] && source $ZSH_LOCAL/pre.zsh

# --- tmux ----------------------------------------------------------------
if zfeature tmux-autostart && [[ -z $TMUX ]] && (( $+commands[tmux] )); then
  tmux new-session
fi

# --- functions -----------------------------------------------------------
# One directory per feature, one file per function: shared, then this OS,
# then this machine, with later roots taking precedence. This must run before
# oh-my-zsh's compinit, which only finds `#compdef` files already in fpath.
for _root in $HOME/.zsh/functions $HOME/.zsh/os/$ZSH_OS/functions $ZSH_LOCAL/functions; do
  [[ -d $_root ]] || continue
  fpath=($_root/*(N-/) $_root $fpath)
  for _fn in $_root/*/*(N.:t) $_root/*(N.:t); do autoload -Uz $_fn; done
done
unset _root _fn

# --- oh-my-zsh and prompt ------------------------------------------------
export ZSH=$HOME/.oh-my-zsh
if [[ -r $ZSH_P10K ]]; then
  ZSH_THEME=""   # powerlevel10k draws the prompt
else
  ZSH_THEME=robbyrussell
fi

if [[ -r $ZSH/oh-my-zsh.sh ]]; then
  _plugins=()
  for _p in $plugins; do
    [[ -d ${ZSH_CUSTOM:-$ZSH/custom}/plugins/$_p || -d $ZSH/plugins/$_p ]] && _plugins+=($_p)
  done
  plugins=($_plugins)
  unset _p _plugins
  source $ZSH/oh-my-zsh.sh
else
  autoload -Uz compinit && compinit
fi

if [[ -r $ZSH_P10K ]]; then
  source $ZSH_P10K
  # To customize the prompt, run `p10k configure` or edit ~/.p10k.zsh
  [[ -r $HOME/.p10k.zsh ]] && source $HOME/.p10k.zsh
fi

# --- aliases and tools ---------------------------------------------------
alias tmux="TERM=xterm-256color tmux"

if (( $+commands[nvim] )); then
  alias vim=nvim
  alias gdvim="nvim --listen /tmp/godot.pipe"   # Godot's external editor
fi

if zfeature nvm && [[ -s $HOME/.nvm/nvm.sh ]]; then
  export NVM_DIR=$HOME/.nvm
  source $NVM_DIR/nvm.sh
  [[ -s $NVM_DIR/bash_completion ]] && source $NVM_DIR/bash_completion
fi

# --- this OS, then this machine ------------------------------------------
[[ -r $HOME/.zsh/os/$ZSH_OS/rc.zsh ]] && source $HOME/.zsh/os/$ZSH_OS/rc.zsh
[[ -r $ZSH_LOCAL/post.zsh ]] && source $ZSH_LOCAL/post.zsh
