function keycloak --wraps='firefox --new-window localhost:8080' --description 'alias keycloak=firefox --new-window localhost:8080'
    firefox --new-window localhost:8080 $argv
end
