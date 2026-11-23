# PATH for login (~/.zprofile) and interactive (~/.zshrc) shells. Sourcing it
# twice is harmless: typeset -U keeps only the first copy of each entry, and
# (N-/) drops directories this machine doesn't have.
typeset -gU path

if [[ $OSTYPE == darwin* ]]; then
  for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x $_brew ]]; then eval "$($_brew shellenv)"; break; fi
  done
  unset _brew
fi

path=(
  $HOME/.local/bin(N-/)
  $HOME/bin(N-/)
  $path
  /usr/local/go/bin(N-/)
  $HOME/go/bin(N-/)
)

# This machine's own entries, kept out of the repo
[[ -r $HOME/.zsh.local/path.zsh ]] && source $HOME/.zsh.local/path.zsh
