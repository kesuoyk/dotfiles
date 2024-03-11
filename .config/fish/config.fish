export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export DOCKER_CONTENT_TRUST=1

eval (/usr/local/bin/brew shellenv)

set -x PATH ./vendor/bin $PATH

alias lla='ls -la'
alias python='python3'

alias d='docker'
alias dc='docker-compose'
alias dce='docker-compose exec'
alias dcr='docker-compose run --rm'

alias g='git'
alias gcom='git branch --merged | fzf | xargs git checkout'
alias gcon='git branch --no-merged | fzf | xargs git checkout'
alias git-delete-merged-branch='git branch --merged | egrep -v "\*" | xargs git branch -d'

function fish_prompt --description 'Write out the prompt'
    printf '%s %s' (set_color green)(prompt_pwd) (set_color yellow)"(*-A-) < "
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
