function pgadmin --wraps='firefox --new-window localhost:4321' --description 'alias pgadmin=firefox --new-window localhost:4321'
    firefox --new-window localhost:4321 $argv
end
