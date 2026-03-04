function qfzf --wraps="fzf --preview 'bat --color=always --style=numbers {}' --style full --bind 'enter:become(nvim {})'" --description "alias qfzf=fzf --preview 'bat --color=always --style=numbers {}' --style full --bind 'enter:become(nvim {})'"
    fzf --preview 'bat --color=always --style=numbers {}' --style full --bind 'enter:become(nvim {})' $argv
end
