# ~/.config/fish/config.fish
set -g fish_greeting ""
starship init fish | source



# pnpm
set -gx PNPM_HOME "/home/guinhas/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
