# ~/.config/fish/config.fish
fish_add_path $HOME/.ghcup/bin
set -Ux GHCUP_INSTALL_STRATEGY prepend
set -e -U GOPATH
set -Ux GOPATH $HOME/go
fish_add_path /usr/local/go/bin $GOPATH/bin

set -g fish_greeting ""
starship init fish | source

# pnpm
set -gx PNPM_HOME "/home/guinhas/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

alias fac="cd $HOME/repos_fac/faculdade" 

function fish_user_key_bindings
	bind \cn toggle_vim_mode

	bind -M insert \cn toggle_vim_mode
	bind -M default \cn toggle_vim_mode
end
