# ~/.config/fish/config.fish
fish_add_path $HOME/.ghcup/bin
set -Ux GHCUP_INSTALL_STRATEGY prepend
set -Ux GOPATH $HOME/go
fish_add_path $GOPATH/bin
fish_add_path ~/extra_apps/idea-IU-253.31033.145/bin

set -g fish_greeting ""
starship init fish | source

# pnpm
set -gx PNPM_HOME "/home/guinhas/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

alias fac="cd $HOME/repos_fac/faculdade" 
