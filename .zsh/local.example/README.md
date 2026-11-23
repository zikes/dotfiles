# Machine-local zsh config

Template for `~/.zsh.local/`, which holds settings for one machine only and is
never committed. Start a new machine with:

```sh
[[ -e ~/.zsh.local ]] || cp -R ~/.zsh/local.example ~/.zsh.local
```

Every file is optional, and everything in these copies is commented out, so
they change nothing until you edit them.

| File | Loaded | Use it for |
|---|---|---|
| `path.zsh` | end of `~/.zsh/path.zsh`, login and interactive shells | extra PATH entries |
| `pre.zsh` | before oh-my-zsh | feature flags, extra plugins, prompt location |
| `post.zsh` | last | private aliases, work settings, overrides |
| `tmux.conf` | end of `~/.tmux.conf.local` | tmux settings for this machine |
| `functions/<feature>/<name>` | autoloaded, ahead of the shared ones | functions and `#compdef` completions |

Only put functions in `functions/<feature>/`. Every file there is autoloaded, so
don't leave notes or READMEs in it.
