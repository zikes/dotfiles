# Linux-only interactive settings, sourced by ~/.zshrc. Linux-only functions
# live in ./functions and are autoloaded the same way as the shared ones.

if (( $+commands[dircolors] )); then
  if [[ -r $HOME/.dircolors ]]; then
    eval "$(dircolors -b $HOME/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi
