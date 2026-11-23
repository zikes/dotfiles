# macOS-only interactive settings, sourced by ~/.zshrc when ZSH_OS=macos.
#
# macOS-only functions go in ./functions/<feature>/<name> and are autoloaded
# like the shared ones. PATH, including Homebrew, is set in ~/.zsh/path.zsh.

# GNU ls colors, when coreutils is installed (brew install coreutils). Without
# it, oh-my-zsh already turns on BSD ls colors.
if (( $+commands[gdircolors] )); then
  if [[ -r $HOME/.dircolors ]]; then
    eval "$(gdircolors -b $HOME/.dircolors)"
  else
    eval "$(gdircolors -b)"
  fi
fi

# Examples, uncomment as needed:
#
# Same tool names as on Linux, if GNU coreutils is installed
# (( $+commands[gls] )) && alias ls='gls --color=auto'
#
# Clipboard, matching what xclip does on Linux
# alias clip=pbcopy
#
# Flush the DNS cache
# alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
